import '../utils/time_utils.dart';
import 'general_event.dart';
import 'general_event_occurrence.dart';
import 'general_schedule.dart';

const generalViewWeek = 'week';
const generalViewDay = 'day';
const generalViewList = 'list';
const generalScheduleSchemaVersion = 3;

Map<String, dynamic>? _asStringKeyedMap(Object? value) {
  if (value is! Map) {
    return null;
  }
  final result = <String, dynamic>{};
  for (final entry in value.entries) {
    final key = entry.key;
    if (key is String) {
      result[key] = entry.value;
    }
  }
  return result;
}

List<dynamic> _listValue(Object? value) {
  return value is List ? value : const <dynamic>[];
}

String _stringValue(Object? value, [String fallback = '']) {
  return value is String ? value : fallback;
}

String? _nullableStringValue(Object? value) {
  return value is String ? value : null;
}

int? _intValue(Object? value) {
  return value is num ? value.toInt() : null;
}

int? _schemaVersionValue(Object? value) {
  if (value is int) {
    return value.toInt();
  }
  if (value is num && value.isFinite && value % 1 == 0) {
    return value.toInt();
  }
  if (value is String) {
    final trimmed = value.trim();
    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      return int.parse(trimmed);
    }
  }
  return null;
}

int? _readSchemaVersion(Map<String, dynamic> json) {
  if (!json.containsKey('schemaVersion')) {
    return null;
  }
  final version = _schemaVersionValue(json['schemaVersion']);
  if (version == null || version <= 0) {
    throw const FormatException('General schedule schemaVersion is invalid.');
  }
  return version;
}

bool? _boolValue(Object? value) {
  return value is bool ? value : null;
}

bool _hasLegacySchedulePayload(Map<String, dynamic> json) {
  return json.containsKey('schedules') || json.containsKey('activeScheduleId');
}

class GeneralReminderAcknowledgement {
  const GeneralReminderAcknowledgement({
    required this.occurrenceKey,
    this.isHandled = true,
    required this.updatedAtIso,
  });

  final String occurrenceKey;
  final bool isHandled;
  final String updatedAtIso;

  Map<String, dynamic> toJson() => {
    'occurrenceKey': occurrenceKey,
    'isHandled': isHandled,
    'updatedAt': updatedAtIso,
  };

  factory GeneralReminderAcknowledgement.fromJson(Map<String, dynamic> json) {
    return GeneralReminderAcknowledgement(
      occurrenceKey: _stringValue(json['occurrenceKey']),
      isHandled: _boolValue(json['isHandled']) ?? true,
      updatedAtIso: _stringValue(json['updatedAt']),
    );
  }

  GeneralReminderAcknowledgement normalized() {
    return GeneralReminderAcknowledgement(
      occurrenceKey: occurrenceKey.trim(),
      isHandled: isHandled,
      updatedAtIso: updatedAtIso.trim().isEmpty
          ? DateTime.now().toIso8601String()
          : updatedAtIso,
    );
  }
}

String normalizeGeneralView(String? value) {
  switch (value) {
    case generalViewDay:
    case generalViewList:
    case generalViewWeek:
      return value!;
    default:
      return generalViewWeek;
  }
}

class GeneralScheduleData {
  const GeneralScheduleData({
    required this.activeScheduleId,
    required this.schedules,
    this.selectedDateIso,
    this.defaultView = generalViewWeek,
    this.showWeekends = true,
    this.dayStartHour = 6,
    this.dayEndHour = 23,
    this.timeGridMinutes = 60,
    this.closeEventPopupOnOutsideTap = true,
    this.reminderAcknowledgements = const [],
  });

  final String activeScheduleId;
  final List<GeneralSchedule> schedules;
  final String? selectedDateIso;
  final String defaultView;
  final bool showWeekends;
  final int dayStartHour;
  final int dayEndHour;
  final int timeGridMinutes;
  final bool closeEventPopupOnOutsideTap;
  final List<GeneralReminderAcknowledgement> reminderAcknowledgements;

  List<GeneralSchedule> get visibleSchedules =>
      schedules.where((s) => s.isVisible).toList()..sort((a, b) {
        final order = a.sortOrder.compareTo(b.sortOrder);
        return order != 0 ? order : a.name.compareTo(b.name);
      });

  GeneralSchedule get activeSchedule {
    for (final s in schedules) {
      if (s.id == activeScheduleId) {
        return s;
      }
    }
    return schedules.first;
  }

  GeneralSchedule? get activeScheduleOrNull =>
      schedules.isEmpty ? null : activeSchedule;

  DateTime get selectedDate {
    final parsed = tryParseStrictIsoDate(selectedDateIso);
    return parsed == null
        ? normalizeDateOnly(DateTime.now())
        : normalizeDateOnly(parsed);
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': generalScheduleSchemaVersion,
    'activeScheduleId': activeScheduleId,
    'schedules': schedules.map((s) => s.toJson()).toList(),
    if (selectedDateIso != null) 'selectedDateIso': selectedDateIso,
    'defaultView': normalizeGeneralView(defaultView),
    'showWeekends': showWeekends,
    'dayStartHour': dayStartHour,
    'dayEndHour': dayEndHour,
    'timeGridMinutes': timeGridMinutes,
    'closeEventPopupOnOutsideTap': closeEventPopupOnOutsideTap,
    'reminderAcknowledgements': reminderAcknowledgements
        .map((item) => item.toJson())
        .toList(),
  };

  factory GeneralScheduleData.fromJson(
    Map<String, dynamic> json, {
    String? localeCode,
  }) {
    final schemaVersion = _readSchemaVersion(json);
    if (schemaVersion != null && schemaVersion > generalScheduleSchemaVersion) {
      throw const FormatException(
        'General schedule schemaVersion is unsupported.',
      );
    }
    if ((schemaVersion ?? 0) < 2 && !_hasLegacySchedulePayload(json)) {
      return GeneralScheduleData.createDefault();
    }

    final schedules =
        _listValue(json['schedules'])
            .map(_asStringKeyedMap)
            .whereType<Map<String, dynamic>>()
            .map(GeneralSchedule.fromJson)
            .toList()
          ..sort((a, b) {
            final order = a.sortOrder.compareTo(b.sortOrder);
            return order != 0 ? order : a.name.compareTo(b.name);
          });
    final withDefaults = schedules.isEmpty
        ? <GeneralSchedule>[createDefaultGeneralSchedule()]
        : schedules;
    final activeId = _stringValue(json['activeScheduleId']);
    final resolvedActiveId = withDefaults.any((s) => s.id == activeId)
        ? activeId
        : withDefaults.first.id;

    return GeneralScheduleData(
      activeScheduleId: resolvedActiveId,
      schedules: [
        for (var i = 0; i < withDefaults.length; i++)
          withDefaults[i].copyWith(sortOrder: i),
      ],
      selectedDateIso: _normalizeDateIso(
        _nullableStringValue(json['selectedDateIso']),
      ),
      defaultView: normalizeGeneralView(
        _nullableStringValue(json['defaultView']),
      ),
      showWeekends: _boolValue(json['showWeekends']) ?? true,
      dayStartHour: (_intValue(json['dayStartHour']) ?? 6).clamp(0, 23).toInt(),
      dayEndHour: (_intValue(json['dayEndHour']) ?? 23).clamp(1, 24).toInt(),
      timeGridMinutes: _normalizeGridMinutes(
        _intValue(json['timeGridMinutes']),
      ),
      closeEventPopupOnOutsideTap:
          _boolValue(json['closeEventPopupOnOutsideTap']) ?? true,
      reminderAcknowledgements: _listValue(json['reminderAcknowledgements'])
          .map(_asStringKeyedMap)
          .whereType<Map<String, dynamic>>()
          .map(GeneralReminderAcknowledgement.fromJson)
          .toList(),
    ).normalized();
  }

  factory GeneralScheduleData.createDefault() {
    final schedule = createDefaultGeneralSchedule();
    return GeneralScheduleData(
      activeScheduleId: schedule.id,
      schedules: [schedule],
      selectedDateIso: _dateIso(DateTime.now()),
    );
  }

  GeneralScheduleData copyWith({
    String? activeScheduleId,
    List<GeneralSchedule>? schedules,
    Object? selectedDateIso = _keepNullable,
    String? defaultView,
    bool? showWeekends,
    int? dayStartHour,
    int? dayEndHour,
    int? timeGridMinutes,
    bool? closeEventPopupOnOutsideTap,
    List<GeneralReminderAcknowledgement>? reminderAcknowledgements,
  }) {
    return GeneralScheduleData(
      activeScheduleId: activeScheduleId ?? this.activeScheduleId,
      schedules: schedules ?? this.schedules,
      selectedDateIso: identical(selectedDateIso, _keepNullable)
          ? this.selectedDateIso
          : selectedDateIso as String?,
      defaultView: normalizeGeneralView(defaultView ?? this.defaultView),
      showWeekends: showWeekends ?? this.showWeekends,
      dayStartHour: dayStartHour ?? this.dayStartHour,
      dayEndHour: dayEndHour ?? this.dayEndHour,
      timeGridMinutes: timeGridMinutes ?? this.timeGridMinutes,
      closeEventPopupOnOutsideTap:
          closeEventPopupOnOutsideTap ?? this.closeEventPopupOnOutsideTap,
      reminderAcknowledgements:
          reminderAcknowledgements ?? this.reminderAcknowledgements,
    ).normalized();
  }

  GeneralScheduleData normalized() {
    final rawSchedules = schedules.isEmpty
        ? <GeneralSchedule>[createDefaultGeneralSchedule()]
        : schedules;
    final usedScheduleIds = <String>{};
    final usedEventIds = <String>{};
    final normalizedSchedules = <GeneralSchedule>[];
    final occurrenceKeyRemaps = <_GeneralOccurrenceKeyRemap>[];
    for (
      var scheduleIndex = 0;
      scheduleIndex < rawSchedules.length;
      scheduleIndex++
    ) {
      final schedule = rawSchedules[scheduleIndex];
      final rawScheduleId = schedule.id.trim();
      final scheduleId = _normalizeUniqueId(
        rawScheduleId,
        fallbackPrefix: 'calendar',
        existingIds: usedScheduleIds,
      );
      usedScheduleIds.add(scheduleId);
      final normalizedEvents = <GeneralEvent>[];
      for (final event in schedule.events) {
        final rawEventId = event.id.trim();
        final normalizedEvent = event.normalized(
          fallbackCalendarId: scheduleId,
        );
        final eventId = _normalizeUniqueId(
          normalizedEvent.id,
          fallbackPrefix: 'evt',
          existingIds: usedEventIds,
        );
        usedEventIds.add(eventId);
        final normalizedEventWithIds = normalizedEvent.copyWith(
          id: eventId,
          calendarId: scheduleId,
        );
        occurrenceKeyRemaps.add(
          _GeneralOccurrenceKeyRemap(
            rawScheduleId: rawScheduleId,
            rawEventId: rawEventId,
            rawStartDateTimeIso: event.startDateTimeIso.trim(),
            scheduleId: scheduleId,
            eventId: eventId,
            startDateTimeIso: normalizedEventWithIds.startDateTimeIso,
          ),
        );
        normalizedEvents.add(normalizedEventWithIds);
      }
      normalizedSchedules.add(
        schedule.copyWith(
          id: scheduleId,
          name: schedule.name.trim().isEmpty
              ? 'My calendar'
              : schedule.name.trim(),
          sortOrder: normalizedSchedules.length,
          events: normalizedEvents,
        ),
      );
    }
    final activeId = normalizedSchedules.any((s) => s.id == activeScheduleId)
        ? activeScheduleId
        : normalizedSchedules.first.id;
    final start = dayStartHour.clamp(0, 23).toInt();
    final end = dayEndHour.clamp(start + 1, 24).toInt();
    final acknowledgementsByKey = <String, GeneralReminderAcknowledgement>{};
    for (final acknowledgement in reminderAcknowledgements) {
      final normalized = acknowledgement.normalized();
      if (normalized.occurrenceKey.isEmpty) {
        continue;
      }
      final occurrenceKey = _remapGeneralOccurrenceKey(
        normalized.occurrenceKey,
        occurrenceKeyRemaps,
      );
      acknowledgementsByKey[occurrenceKey] = GeneralReminderAcknowledgement(
        occurrenceKey: occurrenceKey,
        isHandled: normalized.isHandled,
        updatedAtIso: normalized.updatedAtIso,
      );
    }
    return GeneralScheduleData(
      activeScheduleId: activeId,
      schedules: normalizedSchedules,
      selectedDateIso: selectedDateIso ?? _dateIso(DateTime.now()),
      defaultView: normalizeGeneralView(defaultView),
      showWeekends: showWeekends,
      dayStartHour: start,
      dayEndHour: end,
      timeGridMinutes: _normalizeGridMinutes(timeGridMinutes),
      closeEventPopupOnOutsideTap: closeEventPopupOnOutsideTap,
      reminderAcknowledgements: acknowledgementsByKey.values.toList()
        ..sort((a, b) => a.occurrenceKey.compareTo(b.occurrenceKey)),
    );
  }

  GeneralScheduleData withSchedule(GeneralSchedule schedule) {
    final normalizedSchedule = schedule.normalized();
    final index = schedules.indexWhere((s) => s.id == normalizedSchedule.id);
    final updated = index >= 0
        ? [
            for (var i = 0; i < schedules.length; i++)
              if (i == index) normalizedSchedule else schedules[i],
          ]
        : [
            ...schedules,
            normalizedSchedule.copyWith(sortOrder: schedules.length),
          ];
    return copyWith(schedules: updated);
  }
}

String _dateIso(DateTime date) =>
    normalizeDateOnly(date).toIso8601String().split('T').first;

String? _normalizeDateIso(String? value) {
  final parsed = tryParseStrictIsoDate(value);
  return parsed == null ? null : _dateIso(parsed);
}

int _normalizeGridMinutes(int? value) {
  switch (value) {
    case 15:
    case 30:
    case 60:
      return value!;
    default:
      return 60;
  }
}

String _normalizeUniqueId(
  String rawId, {
  required String fallbackPrefix,
  required Set<String> existingIds,
}) {
  final trimmed = rawId.trim();
  final candidate = trimmed.isEmpty ? fallbackPrefix : trimmed;
  if (!existingIds.contains(candidate)) {
    return candidate;
  }
  final base = trimmed.isEmpty ? fallbackPrefix : _copyIdBase(trimmed);
  var next = base;
  var suffix = 1;
  while (existingIds.contains(next)) {
    next = '${base}_${suffix++}';
  }
  return next;
}

String _copyIdBase(String id) {
  final match = RegExp(r'^(.*_copy)(?:_\d+)?$').firstMatch(id);
  return match == null ? '${id}_copy' : match.group(1)!;
}

String _remapGeneralOccurrenceKey(
  String occurrenceKey,
  List<_GeneralOccurrenceKeyRemap> remaps,
) {
  final parsed = parseGeneralOccurrenceKey(occurrenceKey);
  if (parsed != null) {
    final remap = _selectGeneralOccurrenceKeyRemap(
      remaps,
      calendarId: parsed.calendarId,
      eventId: parsed.eventId,
      startDateTimeIso: parsed.startDateTimeIso,
    );
    if (remap != null) {
      if (remap.mapsToSameIds(
        calendarId: parsed.calendarId,
        eventId: parsed.eventId,
      )) {
        return occurrenceKey;
      }
      return buildGeneralOccurrenceKey(
        remap.scheduleId,
        remap.eventId,
        parsed.startDateTimeIso,
      );
    }
    return occurrenceKey;
  }
  final legacyCandidates = <_GeneralOccurrenceKeyRemap>[];
  String? legacyStartDateTimeIso;
  for (final remap in remaps) {
    final prefix = '${remap.rawScheduleId}|${remap.rawEventId}|';
    if (!occurrenceKey.startsWith(prefix)) {
      continue;
    }
    legacyStartDateTimeIso = occurrenceKey.substring(prefix.length);
    legacyCandidates.add(remap);
  }
  if (legacyStartDateTimeIso != null &&
      tryParseStrictIsoDateTime(legacyStartDateTimeIso) != null) {
    final remap = _selectGeneralOccurrenceKeyRemap(
      legacyCandidates,
      calendarId: legacyCandidates.first.rawScheduleId,
      eventId: legacyCandidates.first.rawEventId,
      startDateTimeIso: legacyStartDateTimeIso,
    );
    if (remap == null) {
      return occurrenceKey;
    }
    if (remap.mapsToSameIds(
      calendarId: remap.rawScheduleId,
      eventId: remap.rawEventId,
    )) {
      return occurrenceKey;
    }
    return buildGeneralOccurrenceKey(
      remap.scheduleId,
      remap.eventId,
      legacyStartDateTimeIso,
    );
  }
  return occurrenceKey;
}

_GeneralOccurrenceKeyRemap? _selectGeneralOccurrenceKeyRemap(
  Iterable<_GeneralOccurrenceKeyRemap> remaps, {
  required String calendarId,
  required String eventId,
  required String startDateTimeIso,
}) {
  final candidates = remaps
      .where((remap) => remap.matchesIds(calendarId, eventId))
      .toList();
  if (candidates.length == 1) {
    return candidates.single;
  }
  final startCandidates = candidates
      .where((remap) => remap.matchesStart(startDateTimeIso))
      .toList();
  return startCandidates.length == 1 ? startCandidates.single : null;
}

class _GeneralOccurrenceKeyRemap {
  const _GeneralOccurrenceKeyRemap({
    required this.rawScheduleId,
    required this.rawEventId,
    required this.rawStartDateTimeIso,
    required this.scheduleId,
    required this.eventId,
    required this.startDateTimeIso,
  });

  final String rawScheduleId;
  final String rawEventId;
  final String rawStartDateTimeIso;
  final String scheduleId;
  final String eventId;
  final String startDateTimeIso;

  bool matchesIds(String calendarId, String eventId) {
    final matchesRaw = calendarId == rawScheduleId && eventId == rawEventId;
    final matchesNormalized =
        calendarId == scheduleId && eventId == this.eventId;
    return matchesRaw || matchesNormalized;
  }

  bool matchesStart(String startDateTimeIso) {
    return _sameOccurrenceStart(startDateTimeIso, rawStartDateTimeIso) ||
        _sameOccurrenceStart(startDateTimeIso, this.startDateTimeIso);
  }

  bool mapsToSameIds({required String calendarId, required String eventId}) {
    return scheduleId == calendarId && this.eventId == eventId;
  }
}

bool _sameOccurrenceStart(String left, String right) {
  if (left == right) {
    return true;
  }
  final leftParsed = tryParseStrictIsoDateTime(left);
  final rightParsed = tryParseStrictIsoDateTime(right);
  return leftParsed != null &&
      rightParsed != null &&
      leftParsed.isAtSameMomentAs(rightParsed);
}

const Symbol _keepNullable = #keep;
