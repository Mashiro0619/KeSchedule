import '../utils/time_utils.dart';
import 'general_event.dart';
import 'general_schedule.dart';

const generalViewWeek = 'week';
const generalViewDay = 'day';
const generalViewList = 'list';
const generalScheduleSchemaVersion = 3;

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
      occurrenceKey: json['occurrenceKey'] as String? ?? '',
      isHandled: json['isHandled'] as bool? ?? true,
      updatedAtIso: json['updatedAt'] as String? ?? '',
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
    final parsed = DateTime.tryParse(selectedDateIso ?? '');
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
    final schemaVersion = (json['schemaVersion'] as num?)?.toInt() ?? 0;
    if (schemaVersion < 2) {
      return GeneralScheduleData.createDefault();
    }

    final schedules =
        (json['schedules'] as List<dynamic>? ?? const <dynamic>[])
            .map(
              (s) => GeneralSchedule.fromJson(
                Map<String, dynamic>.from(s as Map),
              ).normalized(),
            )
            .toList()
          ..sort((a, b) {
            final order = a.sortOrder.compareTo(b.sortOrder);
            return order != 0 ? order : a.name.compareTo(b.name);
          });
    final withDefaults = schedules.isEmpty
        ? <GeneralSchedule>[createDefaultGeneralSchedule()]
        : schedules;
    final activeId = json['activeScheduleId'] as String? ?? '';
    final resolvedActiveId = withDefaults.any((s) => s.id == activeId)
        ? activeId
        : withDefaults.first.id;

    return GeneralScheduleData(
      activeScheduleId: resolvedActiveId,
      schedules: [
        for (var i = 0; i < withDefaults.length; i++)
          withDefaults[i].copyWith(sortOrder: i),
      ],
      selectedDateIso: _normalizeDateIso(json['selectedDateIso'] as String?),
      defaultView: normalizeGeneralView(json['defaultView'] as String?),
      showWeekends: json['showWeekends'] as bool? ?? true,
      dayStartHour: ((json['dayStartHour'] as num?)?.toInt() ?? 6)
          .clamp(0, 23)
          .toInt(),
      dayEndHour: ((json['dayEndHour'] as num?)?.toInt() ?? 23)
          .clamp(1, 24)
          .toInt(),
      timeGridMinutes: _normalizeGridMinutes(
        (json['timeGridMinutes'] as num?)?.toInt(),
      ),
      closeEventPopupOnOutsideTap:
          json['closeEventPopupOnOutsideTap'] as bool? ?? true,
      reminderAcknowledgements:
          (json['reminderAcknowledgements'] as List<dynamic>? ??
                  const <dynamic>[])
              .map(
                (item) => GeneralReminderAcknowledgement.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
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
        : [
            for (var i = 0; i < schedules.length; i++)
              schedules[i].normalized(sortOrderFallback: i),
          ];
    final usedScheduleIds = <String>{};
    final usedEventIds = <String>{};
    final normalizedSchedules = <GeneralSchedule>[];
    for (final schedule in rawSchedules) {
      var scheduleId = schedule.id.trim();
      if (scheduleId.isEmpty || usedScheduleIds.contains(scheduleId)) {
        scheduleId = _generateUniqueId('calendar', usedScheduleIds);
      }
      usedScheduleIds.add(scheduleId);
      final normalizedEvents = <GeneralEvent>[];
      for (final event in schedule.events) {
        var eventId = event.id.trim();
        if (eventId.isEmpty || usedEventIds.contains(eventId)) {
          eventId = _generateUniqueId('evt', usedEventIds);
        }
        usedEventIds.add(eventId);
        normalizedEvents.add(
          event.copyWith(id: eventId, calendarId: scheduleId),
        );
      }
      normalizedSchedules.add(
        schedule.copyWith(
          id: scheduleId,
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
      acknowledgementsByKey[normalized.occurrenceKey] = normalized;
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
  final parsed = DateTime.tryParse(value ?? '');
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

String _generateUniqueId(String prefix, Set<String> existingIds) {
  var stamp = DateTime.now().microsecondsSinceEpoch;
  var candidate = '${prefix}_$stamp';
  while (existingIds.contains(candidate)) {
    stamp += 1;
    candidate = '${prefix}_$stamp';
  }
  return candidate;
}

const Symbol _keepNullable = #keep;
