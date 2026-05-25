import '../utils/time_utils.dart';

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

bool? _boolValue(Object? value) {
  return value is bool ? value : null;
}

enum GeneralEventRecurrence {
  none('none'),
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  custom('custom');

  const GeneralEventRecurrence(this.value);
  final String value;
}

enum GeneralEventRecurrenceUnit {
  day('day'),
  week('week'),
  month('month');

  const GeneralEventRecurrenceUnit(this.value);
  final String value;
}

GeneralEventRecurrence parseGeneralEventRecurrence(String? value) {
  return GeneralEventRecurrence.values.firstWhere(
    (r) => r.value == value,
    orElse: () => GeneralEventRecurrence.none,
  );
}

GeneralEventRecurrenceUnit parseGeneralEventRecurrenceUnit(String? value) {
  return GeneralEventRecurrenceUnit.values.firstWhere(
    (unit) => unit.value == value,
    orElse: () => GeneralEventRecurrenceUnit.week,
  );
}

class GeneralEventReminder {
  const GeneralEventReminder({required this.minutesBefore});

  final int minutesBefore;

  Map<String, dynamic> toJson() => {'minutesBefore': minutesBefore};

  factory GeneralEventReminder.fromJson(Map<String, dynamic> json) {
    return GeneralEventReminder(
      minutesBefore: _intValue(json['minutesBefore']) ?? 0,
    );
  }
}

class GeneralEventRecurrenceRule {
  const GeneralEventRecurrenceRule({
    this.type = GeneralEventRecurrence.none,
    this.interval = 1,
    this.unit = GeneralEventRecurrenceUnit.week,
    this.untilDateIso,
    this.count,
  });

  final GeneralEventRecurrence type;
  final int interval;
  final GeneralEventRecurrenceUnit unit;
  final String? untilDateIso;
  final int? count;

  bool get isRepeating => type != GeneralEventRecurrence.none;

  int get normalizedInterval => interval < 1 ? 1 : interval;

  Map<String, dynamic> toJson() => {
    'type': type.value,
    'interval': normalizedInterval,
    'unit': unit.value,
    if (untilDateIso != null) 'untilDate': untilDateIso,
    if (count != null) 'count': count,
  };

  factory GeneralEventRecurrenceRule.fromJson(Map<String, dynamic> json) {
    final type = parseGeneralEventRecurrence(
      _nullableStringValue(json['type']),
    );
    final legacyUnit = switch (type) {
      GeneralEventRecurrence.daily => GeneralEventRecurrenceUnit.day,
      GeneralEventRecurrence.weekly => GeneralEventRecurrenceUnit.week,
      GeneralEventRecurrence.monthly => GeneralEventRecurrenceUnit.month,
      _ => parseGeneralEventRecurrenceUnit(_nullableStringValue(json['unit'])),
    };
    return GeneralEventRecurrenceRule(
      type: type,
      interval: (_intValue(json['interval']) ?? 1).clamp(1, 999).toInt(),
      unit: legacyUnit,
      untilDateIso: _nullableStringValue(json['untilDate']),
      count: _intValue(json['count']),
    );
  }

  GeneralEventRecurrenceRule copyWith({
    GeneralEventRecurrence? type,
    int? interval,
    GeneralEventRecurrenceUnit? unit,
    Object? untilDateIso = _keepNullable,
    Object? count = _keepNullable,
  }) {
    return GeneralEventRecurrenceRule(
      type: type ?? this.type,
      interval: interval ?? this.interval,
      unit: unit ?? this.unit,
      untilDateIso: identical(untilDateIso, _keepNullable)
          ? this.untilDateIso
          : untilDateIso as String?,
      count: identical(count, _keepNullable) ? this.count : count as int?,
    );
  }
}

class GeneralEvent {
  GeneralEvent({
    required this.id,
    this.calendarId = '',
    required this.title,
    required this.startDateTimeIso,
    required this.endDateTimeIso,
    this.isAllDay = false,
    GeneralEventRecurrenceRule? recurrenceRule,
    GeneralEventRecurrence recurrence = GeneralEventRecurrence.none,
    String? recurrenceEndDateIso,
    this.recurrenceExceptionDateIso = const [],
    this.location = '',
    this.notes = '',
    this.colorValue,
    this.reminders = const [],
    this.createdAtIso,
    this.updatedAtIso,
  }) : recurrenceRule =
           recurrenceRule ??
           GeneralEventRecurrenceRule(
             type: recurrence,
             unit: switch (recurrence) {
               GeneralEventRecurrence.daily => GeneralEventRecurrenceUnit.day,
               GeneralEventRecurrence.monthly =>
                 GeneralEventRecurrenceUnit.month,
               _ => GeneralEventRecurrenceUnit.week,
             },
             untilDateIso: recurrenceEndDateIso,
           );

  final String id;
  final String calendarId;
  final String title;
  final String startDateTimeIso;
  final String endDateTimeIso;
  final bool isAllDay;
  final GeneralEventRecurrenceRule recurrenceRule;
  final List<String> recurrenceExceptionDateIso;
  final String location;
  final String notes;
  final int? colorValue;
  final List<GeneralEventReminder> reminders;
  final String? createdAtIso;
  final String? updatedAtIso;

  GeneralEventRecurrence get recurrence => recurrenceRule.type;

  String? get recurrenceEndDateIso => recurrenceRule.untilDateIso;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'calendarId': calendarId,
      'title': title,
      'start': startDateTimeIso,
      'end': endDateTimeIso,
      'isAllDay': isAllDay,
      'recurrenceRule': recurrenceRule.toJson(),
      'recurrenceExceptionDates': recurrenceExceptionDateIso,
      'location': location,
      'notes': notes,
      'reminders': reminders.map((item) => item.toJson()).toList(),
    };
    if (colorValue != null) {
      json['colorValue'] = colorValue;
    }
    if (createdAtIso != null) {
      json['createdAt'] = createdAtIso;
    }
    if (updatedAtIso != null) {
      json['updatedAt'] = updatedAtIso;
    }
    return json;
  }

  factory GeneralEvent.fromJson(Map<String, dynamic> json) {
    final legacyRecurrence = parseGeneralEventRecurrence(
      _nullableStringValue(json['recurrence']),
    );
    final ruleJson =
        _asStringKeyedMap(json['recurrenceRule']) ??
        <String, dynamic>{
          'type': legacyRecurrence.value,
          if (json['recurrenceEndDate'] != null)
            'untilDate': json['recurrenceEndDate'],
        };
    final remindersJson = _listValue(json['reminders']);
    return GeneralEvent(
      id: _stringValue(json['id']),
      calendarId: _stringValue(json['calendarId']),
      title: _stringValue(json['title']),
      startDateTimeIso: _stringValue(json['start']),
      endDateTimeIso: _stringValue(json['end']),
      isAllDay: _boolValue(json['isAllDay']) ?? false,
      recurrenceRule: GeneralEventRecurrenceRule.fromJson(ruleJson),
      recurrenceExceptionDateIso: _listValue(
        json['recurrenceExceptionDates'],
      ).where((item) => item != null).map((item) => item.toString()).toList(),
      location: _stringValue(json['location']),
      notes: _stringValue(json['notes']),
      colorValue: _intValue(json['colorValue']),
      reminders: remindersJson
          .map(_asStringKeyedMap)
          .whereType<Map<String, dynamic>>()
          .map(GeneralEventReminder.fromJson)
          .toList(),
      createdAtIso: _nullableStringValue(json['createdAt']),
      updatedAtIso: _nullableStringValue(json['updatedAt']),
    );
  }

  GeneralEvent copyWith({
    String? id,
    String? calendarId,
    String? title,
    String? startDateTimeIso,
    String? endDateTimeIso,
    bool? isAllDay,
    GeneralEventRecurrenceRule? recurrenceRule,
    GeneralEventRecurrence? recurrence,
    Object? recurrenceEndDateIso = _keepNullable,
    List<String>? recurrenceExceptionDateIso,
    String? location,
    String? notes,
    Object? colorValue = _keepNullable,
    List<GeneralEventReminder>? reminders,
    Object? createdAtIso = _keepNullable,
    Object? updatedAtIso = _keepNullable,
  }) {
    final nextRecurrenceRule =
        recurrenceRule ??
        (recurrence == null && identical(recurrenceEndDateIso, _keepNullable)
            ? this.recurrenceRule
            : this.recurrenceRule.copyWith(
                type: recurrence,
                unit: switch (recurrence ?? this.recurrenceRule.type) {
                  GeneralEventRecurrence.daily =>
                    GeneralEventRecurrenceUnit.day,
                  GeneralEventRecurrence.monthly =>
                    GeneralEventRecurrenceUnit.month,
                  _ => this.recurrenceRule.unit,
                },
                untilDateIso: recurrenceEndDateIso,
              ));
    return GeneralEvent(
      id: id ?? this.id,
      calendarId: calendarId ?? this.calendarId,
      title: title ?? this.title,
      startDateTimeIso: startDateTimeIso ?? this.startDateTimeIso,
      endDateTimeIso: endDateTimeIso ?? this.endDateTimeIso,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: nextRecurrenceRule,
      recurrenceExceptionDateIso:
          recurrenceExceptionDateIso ?? this.recurrenceExceptionDateIso,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      colorValue: identical(colorValue, _keepNullable)
          ? this.colorValue
          : colorValue as int?,
      reminders: reminders ?? this.reminders,
      createdAtIso: identical(createdAtIso, _keepNullable)
          ? this.createdAtIso
          : createdAtIso as String?,
      updatedAtIso: identical(updatedAtIso, _keepNullable)
          ? this.updatedAtIso
          : updatedAtIso as String?,
    );
  }

  GeneralEvent normalized({required String fallbackCalendarId}) {
    final start = tryParseStrictIsoDateTime(startDateTimeIso) ?? DateTime.now();
    var end =
        tryParseStrictIsoDateTime(endDateTimeIso) ??
        start.add(const Duration(hours: 1));
    if (!end.isAfter(start)) {
      end = isAllDay
          ? normalizeDateOnly(start).add(const Duration(days: 1))
          : start.add(const Duration(hours: 1));
    }
    return copyWith(
      calendarId: calendarId.trim().isEmpty ? fallbackCalendarId : calendarId,
      title: title.trim().isEmpty ? 'Untitled event' : title.trim(),
      startDateTimeIso: start.toIso8601String(),
      endDateTimeIso: end.toIso8601String(),
      recurrenceExceptionDateIso:
          recurrenceExceptionDateIso.map(_normalizeDateIso).toSet().toList()
            ..sort(),
      reminders: reminders.where((item) => item.minutesBefore >= 0).toList(),
    );
  }
}

String _normalizeDateIso(String value) {
  final parsed = tryParseStrictIsoDate(value);
  if (parsed == null) return value;
  return normalizeDateOnly(parsed).toIso8601String().split('T').first;
}

const Symbol _keepNullable = #keep;
