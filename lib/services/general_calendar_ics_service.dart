import 'dart:convert';

import '../models/timetable_models.dart';

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
    for (final schedule in schedules) {
      for (final event in schedule.events) {
        lines.addAll(_exportEvent(schedule, event));
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
      final normalized = line.trim();
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
    return GeneralCalendarIcsImportResult(
      schedules: [schedule.copyWith(events: events)],
      warningItems: warnings,
    );
  }

  List<String> _exportEvent(GeneralSchedule schedule, GeneralEvent event) {
    final start = DateTime.tryParse(event.startDateTimeIso);
    final end = DateTime.tryParse(event.endDateTimeIso);
    if (start == null || end == null) {
      return const [];
    }
    final stamp = _formatUtcDateTime(DateTime.now().toUtc());
    final uid = event.id.trim().isEmpty
        ? 'sked-${start.microsecondsSinceEpoch}@sked.local'
        : '${_escapeText(event.id)}@sked.local';
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
    for (final line in lines) {
      final separator = line.indexOf(':');
      if (separator <= 0) {
        continue;
      }
      final rawName = line.substring(0, separator);
      final value = _unescapeText(line.substring(separator + 1));
      final field = _IcsField.parse(rawName, value);
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
    final isAllDay = startField.params['VALUE'] == 'DATE';
    final endField = fields['DTEND'];
    var end = endField == null ? null : _parseIcsDateTime(endField);
    end ??= isAllDay
        ? normalizeDateOnly(start).add(const Duration(days: 1))
        : start.add(const Duration(hours: 1));
    if (!end.isAfter(start)) {
      end = isAllDay
          ? normalizeDateOnly(start).add(const Duration(days: 1))
          : start.add(const Duration(hours: 1));
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
    final unsupportedFields = _unsupportedFields(fields.keys);
    final unsupportedRRuleParts = <String>[];
    final recurrenceRule = _parseRRule(
      fields['RRULE']?.value,
      warnings,
      unsupportedParts: unsupportedRRuleParts,
    );
    final notes = [
      if (description.isNotEmpty) description,
      if (unsupportedFields.isNotEmpty)
        'Unsupported ICS fields ignored: ${unsupportedFields.join(', ')}',
      if (unsupportedRRuleParts.isNotEmpty)
        'Unsupported RRULE parts ignored: ${unsupportedRRuleParts.join(', ')}',
    ].join('\n\n');
    final unsupported = [
      ...unsupportedFields,
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
      id: uid == null || uid.isEmpty ? _generateEventId() : 'ics_$uid',
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
      params[part.substring(0, separator).toUpperCase()] = part
          .substring(separator + 1)
          .toUpperCase();
    }
    return _IcsField(
      name: parts.first.toUpperCase(),
      params: params,
      value: value,
    );
  }
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
  const limit = 73;
  if (utf8.encode(line).length <= limit) {
    return line;
  }
  final buffer = StringBuffer();
  var segment = StringBuffer();
  var segmentBytes = 0;
  var isFirstSegment = true;
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
    if (segmentBytes > 0 && segmentBytes + charBytes > limit) {
      flushSegment();
    }
    segment.write(char);
    segmentBytes += charBytes;
    if (segmentBytes >= limit) {
      flushSegment();
    }
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
  if (field.params['VALUE'] == 'DATE' || RegExp(r'^\d{8}$').hasMatch(value)) {
    return _parseDate(value);
  }
  final match = RegExp(
    r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})(Z?)$',
  ).firstMatch(value);
  if (match == null) {
    return DateTime.tryParse(value);
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final hour = int.parse(match.group(4)!);
  final minute = int.parse(match.group(5)!);
  final second = int.parse(match.group(6)!);
  final isUtc = match.group(7) == 'Z';
  if (isUtc) {
    return DateTime.utc(year, month, day, hour, minute, second).toLocal();
  }
  return DateTime(year, month, day, hour, minute, second);
}

DateTime? _parseDate(String value) {
  final match = RegExp(r'^(\d{4})(\d{2})(\d{2})').firstMatch(value);
  if (match == null) {
    return DateTime.tryParse(value);
  }
  return DateTime(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
  );
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
    final until = DateTime.tryParse(rule.untilDateIso!);
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
}) {
  if (value == null || value.trim().isEmpty) {
    return const GeneralEventRecurrenceRule();
  }
  final parts = <String, String>{};
  for (final part in value.split(';')) {
    final separator = part.indexOf('=');
    if (separator <= 0) continue;
    parts[part.substring(0, separator).toUpperCase()] = part
        .substring(separator + 1)
        .toUpperCase();
  }
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
  final until = rawUntil == null ? null : _parseDate(rawUntil);
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

List<String> _unsupportedFields(Iterable<String> fields) {
  const supported = {
    'UID',
    'DTSTAMP',
    'SUMMARY',
    'DTSTART',
    'DTEND',
    'LOCATION',
    'DESCRIPTION',
    'RRULE',
  };
  return fields.where((field) => !supported.contains(field)).toList()..sort();
}

String _generateEventId() => 'evt_${DateTime.now().microsecondsSinceEpoch}';
