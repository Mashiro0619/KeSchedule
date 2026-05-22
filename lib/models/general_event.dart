enum GeneralEventRecurrence {
  none('none'),
  weekly('weekly');

  const GeneralEventRecurrence(this.value);
  final String value;
}

GeneralEventRecurrence _parseRecurrence(String? value) {
  return GeneralEventRecurrence.values.firstWhere(
    (r) => r.value == value,
    orElse: () => GeneralEventRecurrence.none,
  );
}

class GeneralEvent {
  const GeneralEvent({
    required this.id,
    required this.title,
    required this.startDateTimeIso,
    required this.endDateTimeIso,
    this.recurrence = GeneralEventRecurrence.none,
    this.recurrenceEndDateIso,
    this.location = '',
    this.notes = '',
    this.colorValue,
    this.createdAtIso,
    this.updatedAtIso,
  });

  final String id;
  final String title;
  final String startDateTimeIso;
  final String endDateTimeIso;
  final GeneralEventRecurrence recurrence;
  final String? recurrenceEndDateIso;
  final String location;
  final String notes;
  final int? colorValue;
  final String? createdAtIso;
  final String? updatedAtIso;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'title': title,
      'start': startDateTimeIso,
      'end': endDateTimeIso,
      'recurrence': recurrence.value,
      'location': location,
      'notes': notes,
    };
    if (recurrenceEndDateIso != null) {
      json['recurrenceEndDate'] = recurrenceEndDateIso;
    }
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
    return GeneralEvent(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startDateTimeIso: json['start'] as String? ?? '',
      endDateTimeIso: json['end'] as String? ?? '',
      recurrence: _parseRecurrence(json['recurrence'] as String?),
      recurrenceEndDateIso: json['recurrenceEndDate'] as String?,
      location: json['location'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      colorValue: (json['colorValue'] as num?)?.toInt(),
      createdAtIso: json['createdAt'] as String?,
      updatedAtIso: json['updatedAt'] as String?,
    );
  }

  GeneralEvent copyWith({
    String? id,
    String? title,
    String? startDateTimeIso,
    String? endDateTimeIso,
    GeneralEventRecurrence? recurrence,
    Object? recurrenceEndDateIso = _keepNullable,
    String? location,
    String? notes,
    int? colorValue,
    Object? createdAtIso = _keepNullable,
    Object? updatedAtIso = _keepNullable,
  }) {
    return GeneralEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      startDateTimeIso: startDateTimeIso ?? this.startDateTimeIso,
      endDateTimeIso: endDateTimeIso ?? this.endDateTimeIso,
      recurrence: recurrence ?? this.recurrence,
      recurrenceEndDateIso: identical(recurrenceEndDateIso, _keepNullable)
          ? this.recurrenceEndDateIso
          : recurrenceEndDateIso as String?,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      colorValue: colorValue ?? this.colorValue,
      createdAtIso: identical(createdAtIso, _keepNullable)
          ? this.createdAtIso
          : createdAtIso as String?,
      updatedAtIso: identical(updatedAtIso, _keepNullable)
          ? this.updatedAtIso
          : updatedAtIso as String?,
    );
  }
}

const Symbol _keepNullable = #keep;
