import 'general_schedule.dart';

class GeneralScheduleData {
  const GeneralScheduleData({
    required this.activeScheduleId,
    required this.schedules,
    this.selectedDateIso,
  });

  final String activeScheduleId;
  final List<GeneralSchedule> schedules;
  final String? selectedDateIso;

  GeneralSchedule get activeSchedule {
    if (schedules.isEmpty) {
      return _createFallbackSchedule();
    }
    for (final s in schedules) {
      if (s.id == activeScheduleId) {
        return s;
      }
    }
    return schedules.first;
  }

  GeneralSchedule? get activeScheduleOrNull {
    if (schedules.isEmpty) return null;
    for (final s in schedules) {
      if (s.id == activeScheduleId) return s;
    }
    return schedules.first;
  }

  Map<String, dynamic> toJson() => {
    'activeScheduleId': activeScheduleId,
    'schedules': schedules.map((s) => s.toJson()).toList(),
    if (selectedDateIso != null) 'selectedDateIso': selectedDateIso,
  };

  factory GeneralScheduleData.fromJson(
    Map<String, dynamic> json, {
    String? localeCode,
  }) {
    final schedules = (json['schedules'] as List<dynamic>? ?? const <dynamic>[])
        .map((s) => GeneralSchedule.fromJson(
              Map<String, dynamic>.from(s as Map),
            ))
        .toList();
    final withDefaults = schedules.isEmpty
        ? <GeneralSchedule>[
            GeneralSchedule(
              id: _generateScheduleId(),
              name: 'My schedule',
              events: const [],
            ),
          ]
        : schedules;
    final activeId = json['activeScheduleId'] as String? ?? '';
    final resolvedActiveId = withDefaults.any((s) => s.id == activeId)
        ? activeId
        : withDefaults.first.id;

    return GeneralScheduleData(
      activeScheduleId: resolvedActiveId,
      schedules: withDefaults,
      selectedDateIso: json['selectedDateIso'] as String?,
    );
  }

  GeneralScheduleData copyWith({
    String? activeScheduleId,
    List<GeneralSchedule>? schedules,
    Object? selectedDateIso = _keepNullable,
  }) {
    return GeneralScheduleData(
      activeScheduleId: activeScheduleId ?? this.activeScheduleId,
      schedules: schedules ?? this.schedules,
      selectedDateIso: identical(selectedDateIso, _keepNullable)
          ? this.selectedDateIso
          : selectedDateIso as String?,
    );
  }

  GeneralScheduleData withSchedule(GeneralSchedule schedule) {
    final index = schedules.indexWhere((s) => s.id == schedule.id);
    final updated = index >= 0
        ? [
            for (var i = 0; i < schedules.length; i++)
              if (i == index) schedule else schedules[i],
          ]
        : [...schedules, schedule];
    return copyWith(schedules: updated);
  }

  static GeneralSchedule _createFallbackSchedule() {
    return GeneralSchedule(
      id: _generateScheduleId(),
      name: 'Untitled',
      events: const [],
    );
  }

  static String _generateScheduleId() {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return 'schedule_$stamp';
  }
}

const Symbol _keepNullable = #keep;
