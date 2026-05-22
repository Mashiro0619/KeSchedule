import '../models/timetable_models.dart';

enum TimetableEntryKind { course, generalEvent }

class TimetableEntry {
  const TimetableEntry({
    required this.id,
    required this.kind,
    required this.title,
    this.location = '',
    this.teacher = '',
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
    this.colorValue,
    this.colorName,
    this.isInactive = false,
    this.isPastEnded = false,
    required this.source,
  });

  final String id;
  final TimetableEntryKind kind;
  final String title;
  final String location;
  final String teacher;
  final int dayOfWeek;
  final int startMinutes;
  final int endMinutes;
  final int? colorValue;
  final String? colorName;
  final bool isInactive;
  final bool isPastEnded;
  final Object source;
}

TimetableEntry courseToEntry(
  CourseItem course, {
  bool isInactive = false,
  bool isPastEnded = false,
}) {
  return TimetableEntry(
    id: course.id,
    kind: TimetableEntryKind.course,
    title: course.name,
    location: course.location,
    teacher: course.teacher,
    dayOfWeek: course.dayOfWeek,
    startMinutes: course.startMinutes,
    endMinutes: course.endMinutes,
    colorName: normalizeCourseColorName(course.name),
    isInactive: isInactive,
    isPastEnded: isPastEnded,
    source: course,
  );
}

TimetableEntry occurrenceToEntry(GeneralEventOccurrence occurrence) {
  final event = occurrence.event;
  return TimetableEntry(
    id: event.id,
    kind: TimetableEntryKind.generalEvent,
    title: event.title,
    location: event.location,
    dayOfWeek: occurrence.start.weekday,
    startMinutes: occurrence.start.hour * 60 + occurrence.start.minute,
    endMinutes: occurrence.end.hour * 60 + occurrence.end.minute,
    colorValue: event.colorValue,
    source: occurrence,
  );
}
