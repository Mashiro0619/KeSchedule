import 'general_event.dart';

class GeneralSchedule {
  const GeneralSchedule({
    required this.id,
    required this.name,
    required this.events,
  });

  final String id;
  final String name;
  final List<GeneralEvent> events;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'events': events.map((e) => e.toJson()).toList(),
  };

  factory GeneralSchedule.fromJson(
    Map<String, dynamic> json, {
    String? localeCode,
  }) {
    return GeneralSchedule(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'My schedule',
      events: (json['events'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => GeneralEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  GeneralSchedule copyWith({
    String? id,
    String? name,
    List<GeneralEvent>? events,
  }) {
    return GeneralSchedule(
      id: id ?? this.id,
      name: name ?? this.name,
      events: events ?? this.events,
    );
  }
}
