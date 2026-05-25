import 'general_event.dart';

const defaultGeneralCalendarColorValue = 0xFF4DB6AC;

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

int? _intValue(Object? value) {
  return value is num ? value.toInt() : null;
}

bool? _boolValue(Object? value) {
  return value is bool ? value : null;
}

class GeneralSchedule {
  const GeneralSchedule({
    required this.id,
    required this.name,
    required this.events,
    this.colorValue = defaultGeneralCalendarColorValue,
    this.isVisible = true,
    this.sortOrder = 0,
  });

  final String id;
  final String name;
  final int colorValue;
  final bool isVisible;
  final int sortOrder;
  final List<GeneralEvent> events;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorValue': colorValue,
    'isVisible': isVisible,
    'sortOrder': sortOrder,
    'events': events.map((e) => e.toJson()).toList(),
  };

  factory GeneralSchedule.fromJson(
    Map<String, dynamic> json, {
    String? localeCode,
  }) {
    final id = _stringValue(json['id']);
    final events = _listValue(json['events'])
        .map(_asStringKeyedMap)
        .whereType<Map<String, dynamic>>()
        .map(GeneralEvent.fromJson)
        .map(
          (e) => e.calendarId.trim().isEmpty ? e.copyWith(calendarId: id) : e,
        )
        .toList();
    return GeneralSchedule(
      id: id,
      name: _stringValue(json['name'], 'My calendar'),
      colorValue:
          _intValue(json['colorValue']) ?? defaultGeneralCalendarColorValue,
      isVisible: _boolValue(json['isVisible']) ?? true,
      sortOrder: _intValue(json['sortOrder']) ?? 0,
      events: events,
    );
  }

  GeneralSchedule copyWith({
    String? id,
    String? name,
    int? colorValue,
    bool? isVisible,
    int? sortOrder,
    List<GeneralEvent>? events,
  }) {
    final nextId = id ?? this.id;
    final nextEvents = events ?? this.events;
    return GeneralSchedule(
      id: nextId,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
      events: nextId == this.id
          ? nextEvents
          : [
              for (final event in nextEvents)
                event.calendarId == this.id || event.calendarId.trim().isEmpty
                    ? event.copyWith(calendarId: nextId)
                    : event,
            ],
    );
  }

  GeneralSchedule normalized({int sortOrderFallback = 0}) {
    final normalizedId = id.trim().isEmpty ? _generateScheduleId() : id.trim();
    return copyWith(
      id: normalizedId,
      name: name.trim().isEmpty ? 'My calendar' : name.trim(),
      sortOrder: sortOrder < 0 ? sortOrderFallback : sortOrder,
      events: [
        for (final event in events)
          event.normalized(fallbackCalendarId: normalizedId),
      ],
    );
  }
}

GeneralSchedule createDefaultGeneralSchedule({
  String name = 'My calendar',
  int colorValue = defaultGeneralCalendarColorValue,
}) {
  return GeneralSchedule(
    id: _generateScheduleId(),
    name: name,
    colorValue: colorValue,
    events: const [],
  );
}

String _generateScheduleId() {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  return 'calendar_$stamp';
}
