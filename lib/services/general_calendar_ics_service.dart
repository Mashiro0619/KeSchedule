import 'dart:convert';

import '../models/timetable_models.dart';
import '../utils/import_id_sanitizer.dart';

enum GeneralCalendarIcsWarningCode {
  missingDtStart,
  unsupportedDtStart,
  adjustedEnd,
  unsupportedFields,
  unsupportedRRuleFrequency,
}

enum GeneralCalendarIcsImportErrorCode { noEvents, noImportableEvents }

class GeneralCalendarIcsImportException implements FormatException {
  const GeneralCalendarIcsImportException(this.code);

  final GeneralCalendarIcsImportErrorCode code;

  @override
  String get message {
    return switch (code) {
      GeneralCalendarIcsImportErrorCode.noEvents => 'No VEVENT entries found.',
      GeneralCalendarIcsImportErrorCode.noImportableEvents =>
        'No importable events found.',
    };
  }

  @override
  int? get offset => null;

  @override
  Object? get source => null;

  @override
  String toString() => 'FormatException: $message';
}

class GeneralCalendarIcsImportWarning {
  const GeneralCalendarIcsImportWarning({
    required this.code,
    this.values = const [],
  });

  final GeneralCalendarIcsWarningCode code;
  final List<String> values;

  String get fallbackMessage {
    return switch (code) {
      GeneralCalendarIcsWarningCode.missingDtStart =>
        'Skipped an event without DTSTART.',
      GeneralCalendarIcsWarningCode.unsupportedDtStart =>
        'Skipped an event with unsupported DTSTART.',
      GeneralCalendarIcsWarningCode.adjustedEnd =>
        'Adjusted an event whose end time was not after start.',
      GeneralCalendarIcsWarningCode.unsupportedFields =>
        'Ignored unsupported fields: ${values.join(', ')}.',
      GeneralCalendarIcsWarningCode.unsupportedRRuleFrequency =>
        'Unsupported RRULE frequency "${values.isEmpty ? '' : values.first}" was ignored.',
    };
  }
}

class GeneralCalendarIcsImportResult {
  const GeneralCalendarIcsImportResult({
    required this.schedules,
    this.warningItems = const [],
  });

  final List<GeneralSchedule> schedules;
  final List<GeneralCalendarIcsImportWarning> warningItems;

  List<String> get warnings =>
      warningItems.map((item) => item.fallbackMessage).toList();
}

class GeneralCalendarIcsService {
  const GeneralCalendarIcsService();

  String exportSchedules(List<GeneralSchedule> schedules) {
    final lines = <String>[
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Sked//General Calendar//EN',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
    ];
    final usedUids = <String>{};
    var fallbackUidSequence = 0;
    for (final schedule in schedules) {
      for (final event in schedule.events) {
        lines.addAll(
          _exportEvent(schedule, event, usedUids, fallbackUidSequence++),
        );
      }
    }
    lines.add('END:VCALENDAR');
    return lines.map(_foldLine).join('\r\n');
  }

  GeneralCalendarIcsImportResult importSchedules(
    String source, {
    String? calendarName,
    int colorValue = defaultGeneralCalendarColorValue,
  }) {
    final unfolded = _unfoldLines(source);
    final blocks = <List<String>>[];
    var current = <String>[];
    var inEvent = false;
    for (final line in unfolded) {
      final normalized = line.trim().toUpperCase();
      if (normalized == 'BEGIN:VEVENT') {
        inEvent = true;
        current = <String>[];
        continue;
      }
      if (normalized == 'END:VEVENT') {
        if (inEvent) {
          blocks.add(current);
        }
        inEvent = false;
        current = <String>[];
        continue;
      }
      if (inEvent) {
        current.add(line);
      }
    }
    if (blocks.isEmpty) {
      throw const GeneralCalendarIcsImportException(
        GeneralCalendarIcsImportErrorCode.noEvents,
      );
    }

    final schedule = createDefaultGeneralSchedule(
      name: calendarName?.trim().isNotEmpty == true
          ? calendarName!.trim()
          : 'Imported calendar',
      colorValue: colorValue,
    );
    final warnings = <GeneralCalendarIcsImportWarning>[];
    final events = <GeneralEvent>[];
    for (final block in blocks) {
      final event = _importEvent(block, schedule.id, warnings);
      if (event != null) {
        events.add(event);
      }
    }
    if (events.isEmpty) {
      throw const GeneralCalendarIcsImportException(
        GeneralCalendarIcsImportErrorCode.noImportableEvents,
      );
    }
    events.sort((a, b) => a.startDateTimeIso.compareTo(b.startDateTimeIso));
    final normalizedEvents = _deduplicateImportedEventIds(events, schedule.id);
    return GeneralCalendarIcsImportResult(
      schedules: [schedule.copyWith(events: normalizedEvents)],
      warningItems: warnings,
    );
  }

  List<String> _exportEvent(
    GeneralSchedule schedule,
    GeneralEvent event,
    Set<String> usedUids,
    int fallbackUidSequence,
  ) {
    final start = tryParseStrictIsoDateTime(event.startDateTimeIso);
    final end = tryParseStrictIsoDateTime(event.endDateTimeIso);
    if (start == null || end == null) {
      return const [];
    }
    final stamp = _formatUtcDateTime(DateTime.now().toUtc());
    final rawUid = event.id.trim().isEmpty
        ? 'sked-${start.microsecondsSinceEpoch}-$fallbackUidSequence@sked.local'
        : '${_escapeText(event.id)}@sked.local';
    final uid = _uniqueIcsUid(rawUid, usedUids);
    final description = [
      if (event.notes.trim().isNotEmpty) event.notes.trim(),
      'Calendar: ${schedule.name}',
    ].join('\n');
    final lines = <String>[
      'BEGIN:VEVENT',
      'UID:$uid',
      'DTSTAMP:$stamp',
      'SUMMARY:${_escapeText(event.title)}',
    ];
    if (event.isAllDay) {
      lines.add('DTSTART;VALUE=DATE:${_formatDate(start)}');
      lines.add('DTEND;VALUE=DATE:${_formatDate(end)}');
    } else {
      lines.add('DTSTART:${_formatLocalDateTime(start)}');
      lines.add('DTEND:${_formatLocalDateTime(end)}');
    }
    if (event.location.trim().isNotEmpty) {
      lines.add('LOCATION:${_escapeText(event.location.trim())}');
    }
    if (description.trim().isNotEmpty) {
      lines.add('DESCRIPTION:${_escapeText(description)}');
    }
    final rule = _exportRRule(event.recurrenceRule);
    if (rule != null) {
      lines.add('RRULE:$rule');
    }
    lines.add('END:VEVENT');
    return lines;
  }

  GeneralEvent? _importEvent(
    List<String> lines,
    String calendarId,
    List<GeneralCalendarIcsImportWarning> warnings,
  ) {
    final fields = <String, _IcsField>{};
    final duplicateFields = <String>{};
    final unsupportedComponents = <String>{};
    var nestedComponentDepth = 0;
    for (final line in lines) {
      final separator = _findIcsValueSeparator(line);
      if (separator <= 0) {
        continue;
      }
      final rawName = line.substring(0, separator);
      final value = _unescapeText(line.substring(separator + 1));
      final field = _IcsField.parse(rawName, value);
      if (field.name == 'BEGIN') {
        final component = field.value.trim().toUpperCase();
        if (component.isNotEmpty && component != 'VEVENT') {
          unsupportedComponents.add(component);
          nestedComponentDepth += 1;
        }
        continue;
      }
      if (nestedComponentDepth > 0) {
        if (field.name == 'END') {
          nestedComponentDepth -= 1;
        }
        continue;
      }
      if (field.name == 'END') {
        continue;
      }
      if (fields.containsKey(field.name)) {
        duplicateFields.add(field.name);
      }
      fields[field.name] = field;
    }
    final startField = fields['DTSTART'];
    if (startField == null) {
      warnings.add(
        const GeneralCalendarIcsImportWarning(
          code: GeneralCalendarIcsWarningCode.missingDtStart,
        ),
      );
      return null;
    }
    final start = _parseIcsDateTime(startField);
    if (start == null) {
      warnings.add(
        const GeneralCalendarIcsImportWarning(
          code: GeneralCalendarIcsWarningCode.unsupportedDtStart,
        ),
      );
      return null;
    }
    final isAllDay = _isIcsDateOnly(startField);
    final endField = fields['DTEND'];
    final durationField = fields['DURATION'];
    final ignoredSupportedFields = <String>[];
    var adjustedEnd = false;
    var end = endField == null ? null : _parseIcsDateTime(endField);
    final hasInvalidEnd = endField != null && end == null;
    if (durationField != null) {
      if (endField == null || hasInvalidEnd) {
        final duration = _parseIcsDuration(durationField.value);
        if (duration == null) {
          ignoredSupportedFields.add('DURATION');
          adjustedEnd = true;
        } else {
          end = start.add(duration);
          adjustedEnd = adjustedEnd || hasInvalidEnd;
        }
      } else {
        ignoredSupportedFields.add('DURATION');
      }
    } else if (hasInvalidEnd) {
      adjustedEnd = true;
    }
    if (end != null && isAllDay) {
      final normalizedEnd = normalizeDateOnly(end);
      if (normalizedEnd != end) {
        adjustedEnd = true;
      }
      end = normalizedEnd;
    }
    end ??= isAllDay
        ? normalizeDateOnly(start).add(const Duration(days: 1))
        : start.add(const Duration(hours: 1));
    if (!end.isAfter(start)) {
      adjustedEnd = true;
      end = isAllDay
          ? normalizeDateOnly(start).add(const Duration(days: 1))
          : start.add(const Duration(hours: 1));
    }
    if (adjustedEnd) {
      warnings.add(
        const GeneralCalendarIcsImportWarning(
          code: GeneralCalendarIcsWarningCode.adjustedEnd,
        ),
      );
    }

    final uid = fields['UID']?.value.trim();
    final now = DateTime.now().toIso8601String();
    final title = fields['SUMMARY']?.value.trim();
    final description = fields['DESCRIPTION']?.value.trim() ?? '';
    final unsupportedFields = [
      ..._unsupportedFields(fields.keys),
      ..._unsupportedFieldParameters(fields.values),
      ...unsupportedComponents,
      ...ignoredSupportedFields,
    ]..sort();
    final duplicateFieldNames = duplicateFields.toList()..sort();
    final unsupportedRRuleParts = <String>[];
    final duplicateRRuleParts = <String>[];
    final recurrenceRule = _parseRRule(
      fields['RRULE']?.value,
      warnings,
      unsupportedParts: unsupportedRRuleParts,
      duplicateParts: duplicateRRuleParts,
    );
    final notes = [
      if (description.isNotEmpty) description,
      if (unsupportedFields.isNotEmpty)
        'Unsupported ICS fields ignored: ${unsupportedFields.join(', ')}',
      if (duplicateFieldNames.isNotEmpty)
        'Duplicate ICS fields overwritten: ${duplicateFieldNames.join(', ')}',
      if (duplicateRRuleParts.isNotEmpty)
        'Duplicate RRULE parts overwritten: ${duplicateRRuleParts.join(', ')}',
      if (unsupportedRRuleParts.isNotEmpty)
        'Unsupported RRULE parts ignored: ${unsupportedRRuleParts.join(', ')}',
    ].join('\n\n');
    final unsupported = [
      ...unsupportedFields,
      for (final field in duplicateFieldNames) 'DUPLICATE:$field',
      for (final part in duplicateRRuleParts) 'RRULE:DUPLICATE:$part',
      for (final part in unsupportedRRuleParts) 'RRULE:$part',
    ]..sort();
    if (unsupported.isNotEmpty) {
      warnings.add(
        GeneralCalendarIcsImportWarning(
          code: GeneralCalendarIcsWarningCode.unsupportedFields,
          values: unsupported,
        ),
      );
    }

    return GeneralEvent(
      id: _importedEventIdFromUid(uid),
      calendarId: calendarId,
      title: title == null || title.isEmpty ? 'Untitled event' : title,
      startDateTimeIso: start.toIso8601String(),
      endDateTimeIso: end.toIso8601String(),
      isAllDay: isAllDay,
      recurrenceRule: recurrenceRule,
      location: fields['LOCATION']?.value.trim() ?? '',
      notes: notes,
      createdAtIso: now,
      updatedAtIso: now,
    ).normalized(fallbackCalendarId: calendarId);
  }
}

class _IcsField {
  const _IcsField({
    required this.name,
    required this.params,
    required this.value,
  });

  final String name;
  final Map<String, String> params;
  final String value;

  static _IcsField parse(String rawName, String value) {
    final parts = rawName.split(';');
    final params = <String, String>{};
    for (final part in parts.skip(1)) {
      final separator = part.indexOf('=');
      if (separator <= 0) continue;
      params[part.substring(0, separator).toUpperCase()] = part.substring(
        separator + 1,
      );
    }
    return _IcsField(
      name: parts.first.toUpperCase(),
      params: params,
      value: value,
    );
  }
}

int _findIcsValueSeparator(String line) {
  var inQuotedParam = false;
  for (var index = 0; index < line.length; index++) {
    final char = line[index];
    if (char == '"') {
      inQuotedParam = !inQuotedParam;
      continue;
    }
    if (char == ':' && !inQuotedParam) {
      return index;
    }
  }
  return -1;
}

List<String> _unfoldLines(String source) {
  final raw = source
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n');
  final result = <String>[];
  for (final line in raw) {
    if ((line.startsWith(' ') || line.startsWith('\t')) && result.isNotEmpty) {
      result[result.length - 1] += line.substring(1);
    } else {
      result.add(line);
    }
  }
  return result;
}

String _foldLine(String line) {
  const maxLineBytes = 75;
  if (utf8.encode(line).length <= maxLineBytes) {
    return line;
  }
  final buffer = StringBuffer();
  var segment = StringBuffer();
  var segmentBytes = 0;
  var isFirstSegment = true;

  int currentSegmentLimit() => isFirstSegment ? maxLineBytes : maxLineBytes - 1;

  void flushSegment() {
    if (!isFirstSegment) {
      buffer.write('\r\n ');
    }
    buffer.write(segment);
    segment = StringBuffer();
    segmentBytes = 0;
    isFirstSegment = false;
  }

  for (final rune in line.runes) {
    final char = String.fromCharCode(rune);
    final charBytes = utf8.encode(char).length;
    if (segmentBytes > 0 && segmentBytes + charBytes > currentSegmentLimit()) {
      flushSegment();
    }
    segment.write(char);
    segmentBytes += charBytes;
  }
  if (segmentBytes > 0 || isFirstSegment) {
    flushSegment();
  }
  return buffer.toString();
}

String _escapeText(String value) {
  return value
      .replaceAll('\\', r'\\')
      .replaceAll('\n', r'\n')
      .replaceAll(',', r'\,')
      .replaceAll(';', r'\;');
}

String _unescapeText(String value) {
  final buffer = StringBuffer();
  for (var index = 0; index < value.length; index++) {
    final char = value[index];
    if (char != '\\' || index == value.length - 1) {
      buffer.write(char);
      continue;
    }
    final next = value[++index];
    switch (next) {
      case 'n':
      case 'N':
        buffer.write('\n');
      case ',':
        buffer.write(',');
      case ';':
        buffer.write(';');
      case '\\':
        buffer.write('\\');
      default:
        buffer
          ..write('\\')
          ..write(next);
    }
  }
  return buffer.toString();
}

String _formatDate(DateTime value) {
  return '${value.year.toString().padLeft(4, '0')}'
      '${value.month.toString().padLeft(2, '0')}'
      '${value.day.toString().padLeft(2, '0')}';
}

String _formatLocalDateTime(DateTime value) {
  return '${_formatDate(value)}T'
      '${value.hour.toString().padLeft(2, '0')}'
      '${value.minute.toString().padLeft(2, '0')}'
      '${value.second.toString().padLeft(2, '0')}';
}

String _formatUtcDateTime(DateTime value) => '${_formatLocalDateTime(value)}Z';

DateTime? _parseIcsDateTime(_IcsField field) {
  final value = field.value.trim();
  if (_isIcsDateOnly(field)) {
    return _parseDate(value);
  }
  final match = RegExp(
    r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})(Z|[+-]\d{2}:?\d{2})?$',
  ).firstMatch(value);
  if (match == null) {
    return _parseIsoDateTime(value);
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4)!);
  final minute = int.parse(match.group(5)!);
  final second = int.parse(match.group(6)!);
  final offset = match.group(7);
  if (offset == 'Z') {
    return _strictDateTime(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      isUtc: true,
    )?.toLocal();
  }
  if (offset != null && offset.isNotEmpty) {
    return _strictDateTimeWithOffset(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      offset: offset,
    );
  }
  return _strictDateTime(
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
  );
}

bool _isIcsDateOnly(_IcsField field) {
  final value = field.value.trim();
  return field.params['VALUE']?.toUpperCase() == 'DATE' ||
      RegExp(r'^\d{8}$').hasMatch(value) ||
      RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value);
}

DateTime? _parseDate(String value, {bool allowDateTime = false}) {
  final trimmed = value.trim();
  final basicPattern = allowDateTime
      ? RegExp(r'^(\d{4})(\d{2})(\d{2})(?:T.*)?$')
      : RegExp(r'^(\d{4})(\d{2})(\d{2})$');
  final basicMatch = basicPattern.firstMatch(trimmed);
  if (basicMatch != null) {
    return _strictDateTime(
      year: int.parse(basicMatch.group(1)!),
      month: int.parse(basicMatch.group(2)!),
      day: int.parse(basicMatch.group(3)!),
    );
  }

  final isoPattern = allowDateTime
      ? RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:[T ].*)?$')
      : RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
  final isoMatch = isoPattern.firstMatch(trimmed);
  if (isoMatch == null) {
    return null;
  }
  return _strictDateTime(
    year: int.parse(isoMatch.group(1)!),
    month: int.parse(isoMatch.group(2)!),
    day: int.parse(isoMatch.group(3)!),
  );
}

DateTime? _parseIsoDateTime(String value) {
  final match = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})(?:[T ](\d{2}):(\d{2})(?::(\d{2}))?)?(Z|[+-]\d{2}:?\d{2})?$',
  ).firstMatch(value.trim());
  if (match == null) {
    return null;
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4) ?? '0');
  final minute = int.parse(match.group(5) ?? '0');
  final second = int.parse(match.group(6) ?? '0');
  final offset = match.group(7);
  final local = _strictDateTime(
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
  );
  if (local == null) {
    return null;
  }
  if (offset == null || offset.isEmpty) {
    return local;
  }
  final parsed = DateTime.tryParse(value);
  return parsed?.isUtc == true ? parsed!.toLocal() : parsed;
}

Duration? _parseIcsDuration(String value) {
  final trimmed = value.trim().toUpperCase();
  final weekMatch = RegExp(r'^\+?P(\d+)W$').firstMatch(trimmed);
  if (weekMatch != null) {
    final weeks = int.tryParse(weekMatch.group(1)!);
    if (weeks == null || weeks < 1 || weeks > 5200) {
      return null;
    }
    return Duration(days: weeks * 7);
  }

  final match = RegExp(
    r'^\+?P(?:(\d+)D)?(?:T(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?)?$',
  ).firstMatch(trimmed);
  if (match == null) {
    return null;
  }
  final hasDatePart = match.group(1) != null;
  final hasTimePart =
      match.group(2) != null ||
      match.group(3) != null ||
      match.group(4) != null;
  if (!hasDatePart && !hasTimePart) {
    return null;
  }
  if (trimmed.contains('T') && !hasTimePart) {
    return null;
  }
  final days = int.tryParse(match.group(1) ?? '0');
  final hours = int.tryParse(match.group(2) ?? '0');
  final minutes = int.tryParse(match.group(3) ?? '0');
  final seconds = int.tryParse(match.group(4) ?? '0');
  if (days == null || hours == null || minutes == null || seconds == null) {
    return null;
  }
  if (days > 36500 || hours > 999999 || minutes > 999999 || seconds > 999999) {
    return null;
  }
  final duration = Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
  );
  return duration > Duration.zero ? duration : null;
}

DateTime? _strictDateTime({
  required int year,
  required int month,
  required int day,
  int hour = 0,
  int minute = 0,
  int second = 0,
  bool isUtc = false,
}) {
  if (year < 1 ||
      year > 9999 ||
      month < 1 ||
      month > 12 ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59 ||
      second < 0 ||
      second > 59) {
    return null;
  }
  final maxDay = DateTime(year, month + 1, 0).day;
  if (day < 1 || day > maxDay) {
    return null;
  }
  return isUtc
      ? DateTime.utc(year, month, day, hour, minute, second)
      : DateTime(year, month, day, hour, minute, second);
}

DateTime? _strictDateTimeWithOffset({
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int second,
  required String offset,
}) {
  final local = _strictDateTime(
    year: year,
    month: month,
    day: day,
    hour: hour,
    minute: minute,
    second: second,
  );
  if (local == null) {
    return null;
  }
  final match = RegExp(r'^([+-])(\d{2}):?(\d{2})$').firstMatch(offset);
  if (match == null) {
    return null;
  }
  final offsetHours = int.parse(match.group(2)!);
  final offsetMinutes = int.parse(match.group(3)!);
  if (offsetHours > 23 || offsetMinutes > 59) {
    return null;
  }
  final duration = Duration(hours: offsetHours, minutes: offsetMinutes);
  final utcBase = DateTime.utc(year, month, day, hour, minute, second);
  return (match.group(1) == '+'
          ? utcBase.subtract(duration)
          : utcBase.add(duration))
      .toLocal();
}

String? _exportRRule(GeneralEventRecurrenceRule rule) {
  if (!rule.isRepeating) {
    return null;
  }
  final unit = switch (rule.type) {
    GeneralEventRecurrence.daily => GeneralEventRecurrenceUnit.day,
    GeneralEventRecurrence.weekly => GeneralEventRecurrenceUnit.week,
    GeneralEventRecurrence.monthly => GeneralEventRecurrenceUnit.month,
    GeneralEventRecurrence.custom => rule.unit,
    GeneralEventRecurrence.none => rule.unit,
  };
  final freq = switch (unit) {
    GeneralEventRecurrenceUnit.day => 'DAILY',
    GeneralEventRecurrenceUnit.week => 'WEEKLY',
    GeneralEventRecurrenceUnit.month => 'MONTHLY',
  };
  final parts = <String>['FREQ=$freq'];
  if (rule.normalizedInterval > 1 ||
      rule.type == GeneralEventRecurrence.custom) {
    parts.add('INTERVAL=${rule.normalizedInterval}');
  }
  if (rule.count != null && rule.count! > 0) {
    parts.add('COUNT=${rule.count}');
  } else if (rule.untilDateIso != null) {
    final until = tryParseStrictIsoDate(rule.untilDateIso!);
    if (until != null) {
      parts.add('UNTIL=${_formatDate(until)}');
    }
  }
  return parts.join(';');
}

GeneralEventRecurrenceRule _parseRRule(
  String? value,
  List<GeneralCalendarIcsImportWarning> warnings, {
  List<String>? unsupportedParts,
  List<String>? duplicateParts,
}) {
  if (value == null || value.trim().isEmpty) {
    return const GeneralEventRecurrenceRule();
  }
  final parts = <String, String>{};
  final duplicates = <String>{};
  for (final part in value.split(';')) {
    final separator = part.indexOf('=');
    if (separator <= 0) continue;
    final key = part.substring(0, separator).toUpperCase();
    if (parts.containsKey(key)) {
      duplicates.add(key);
    }
    parts[key] = part.substring(separator + 1).toUpperCase();
  }
  duplicateParts?.addAll(duplicates.toList()..sort());
  const supportedParts = {'FREQ', 'INTERVAL', 'COUNT', 'UNTIL'};
  final unsupported =
      parts.keys
          .where((key) => !supportedParts.contains(key))
          .map((key) => '$key=${parts[key]}')
          .toList()
        ..sort();
  if (unsupported.isNotEmpty) {
    unsupportedParts?.addAll(unsupported);
    return const GeneralEventRecurrenceRule();
  }
  final freq = parts['FREQ'];
  final unsupportedValues = <String>[];
  final rawInterval = parts['INTERVAL'];
  final interval = rawInterval == null ? 1 : int.tryParse(rawInterval) ?? -1;
  if (interval < 1) {
    unsupportedValues.add('INTERVAL=$rawInterval');
  }
  final rawCount = parts['COUNT'];
  final count = rawCount == null ? null : int.tryParse(rawCount);
  if (rawCount != null && (count == null || count < 1)) {
    unsupportedValues.add('COUNT=$rawCount');
  }
  final rawUntil = parts['UNTIL'];
  final until = rawUntil == null ? null : _parseRRuleUntil(rawUntil);
  if (rawUntil != null && until == null) {
    unsupportedValues.add('UNTIL=$rawUntil');
  }
  final unit = switch (freq) {
    'DAILY' => GeneralEventRecurrenceUnit.day,
    'WEEKLY' => GeneralEventRecurrenceUnit.week,
    'MONTHLY' => GeneralEventRecurrenceUnit.month,
    _ => null,
  };
  if (unit == null) {
    warnings.add(
      GeneralCalendarIcsImportWarning(
        code: GeneralCalendarIcsWarningCode.unsupportedRRuleFrequency,
        values: [freq ?? ''],
      ),
    );
    if (freq != null && freq.isNotEmpty) {
      unsupportedValues.add('FREQ=$freq');
    }
  }
  if (unsupportedValues.isNotEmpty) {
    unsupportedParts?.addAll(unsupportedValues..sort());
    return const GeneralEventRecurrenceRule();
  }
  if (unit == null) {
    return const GeneralEventRecurrenceRule();
  }
  final type = interval <= 1
      ? switch (unit) {
          GeneralEventRecurrenceUnit.day => GeneralEventRecurrence.daily,
          GeneralEventRecurrenceUnit.week => GeneralEventRecurrence.weekly,
          GeneralEventRecurrenceUnit.month => GeneralEventRecurrence.monthly,
        }
      : GeneralEventRecurrence.custom;
  return GeneralEventRecurrenceRule(
    type: type,
    interval: interval.clamp(1, 999).toInt(),
    unit: unit,
    untilDateIso: until?.toIso8601String().split('T').first,
    count: count == null || count < 1 ? null : count,
  );
}

DateTime? _parseRRuleUntil(String value) {
  final trimmed = value.trim();
  final date = _parseDate(trimmed);
  if (date != null) {
    return date;
  }

  final basicMatch = RegExp(
    r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})Z?$',
  ).firstMatch(trimmed);
  if (basicMatch != null) {
    return _strictDateTime(
      year: int.parse(basicMatch.group(1)!),
      month: int.parse(basicMatch.group(2)!),
      day: int.parse(basicMatch.group(3)!),
      hour: int.parse(basicMatch.group(4)!),
      minute: int.parse(basicMatch.group(5)!),
      second: int.parse(basicMatch.group(6)!),
    );
  }

  final isoMatch = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2}))?(Z|[+-]\d{2}:?\d{2})?$',
  ).firstMatch(trimmed);
  if (isoMatch == null) {
    return null;
  }
  return _strictDateTime(
    year: int.parse(isoMatch.group(1)!),
    month: int.parse(isoMatch.group(2)!),
    day: int.parse(isoMatch.group(3)!),
    hour: int.parse(isoMatch.group(4)!),
    minute: int.parse(isoMatch.group(5)!),
    second: int.parse(isoMatch.group(6) ?? '0'),
  );
}

List<String> _unsupportedFields(Iterable<String> fields) {
  const supported = {
    'UID',
    'DTSTAMP',
    'SUMMARY',
    'DTSTART',
    'DTEND',
    'DURATION',
    'LOCATION',
    'DESCRIPTION',
    'RRULE',
  };
  return fields.where((field) => !supported.contains(field)).toList()..sort();
}

List<String> _unsupportedFieldParameters(Iterable<_IcsField> fields) {
  final unsupported = <String>[];
  for (final field in fields) {
    final timezoneId = field.params['TZID']?.trim();
    if (timezoneId != null && timezoneId.isNotEmpty) {
      unsupported.add('${field.name};TZID=$timezoneId');
    }
  }
  return unsupported..sort();
}

String _uniqueIcsUid(String rawUid, Set<String> usedUids) {
  var candidate = rawUid;
  var suffix = 1;
  final atIndex = rawUid.lastIndexOf('@');
  final base = atIndex > 0 ? rawUid.substring(0, atIndex) : rawUid;
  final domain = atIndex > 0 ? rawUid.substring(atIndex) : '';
  while (usedUids.contains(candidate)) {
    candidate = '${base}_$suffix$domain';
    suffix += 1;
  }
  usedUids.add(candidate);
  return candidate;
}

var _generatedEventIdCounter = 0;

String _generateEventId() {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  final suffix = _generatedEventIdCounter++;
  return 'evt_${stamp}_$suffix';
}

String _importedEventIdFromUid(String? uid) {
  final source = uid?.trim() ?? '';
  if (source.isEmpty) {
    return _generateEventId();
  }
  final safe = sanitizeImportedId(source);
  if (safe.isEmpty) {
    return _generateEventId();
  }
  return 'ics_$safe';
}

List<GeneralEvent> _deduplicateImportedEventIds(
  List<GeneralEvent> events,
  String calendarId,
) {
  final usedIds = <String>{};
  return [
    for (final event in events)
      event.copyWith(
        id: _uniqueImportedEventId(event.id, usedIds),
        calendarId: calendarId,
      ),
  ];
}

String _uniqueImportedEventId(String rawId, Set<String> usedIds) {
  final base = rawId.trim();
  var candidate = base.isEmpty ? _generateEventId() : base;
  var suffix = 1;
  while (usedIds.contains(candidate)) {
    candidate = base.isEmpty ? _generateEventId() : '${base}_${suffix++}';
  }
  usedIds.add(candidate);
  return candidate;
}
