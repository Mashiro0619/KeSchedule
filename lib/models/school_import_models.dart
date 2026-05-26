import '../utils/constants.dart';
import '../utils/time_utils.dart';

Map<String, dynamic> _asStringKeyedMap(Object? value) {
  if (value is! Map) {
    return const <String, dynamic>{};
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

List<int> _positiveIntList(Object? value, {required int maxValue}) {
  if (value is! List) {
    return const [];
  }
  final result = <int>{};
  for (final item in value.whereType<num>()) {
    if (!item.isFinite || item <= 0 || item > maxValue || item % 1 != 0) {
      continue;
    }
    result.add(item.toInt());
  }
  return result.toList()..sort();
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

double? _doubleValue(Object? value) {
  return value is num ? value.toDouble() : null;
}

bool? _boolValue(Object? value) {
  return value is bool ? value : null;
}

bool _hasTimetablePayload(Map<String, dynamic> json) {
  return json.containsKey('name') ||
      json.containsKey('startDate') ||
      json.containsKey('totalWeeks') ||
      json.containsKey('periodTimeSet') ||
      json.containsKey('courses');
}

enum TimetableImportMode { addAsNew, replaceActive }

class SchoolImportSourcePayload {
  const SchoolImportSourcePayload({
    required this.url,
    required this.title,
    required this.content,
  });

  final String url;
  final String title;
  final String content;
}

class SchoolImportParseRequest {
  const SchoolImportParseRequest({
    required this.source,
    required this.locale,
    this.sourceHint,
  });

  final SchoolImportSourcePayload source;
  final String locale;
  final String? sourceHint;
}

class SchoolImportPagePayload {
  const SchoolImportPagePayload({
    required this.url,
    required this.title,
    required this.html,
    required this.locale,
    this.sourceHint,
  });

  factory SchoolImportPagePayload.fromParseRequest(
    SchoolImportParseRequest request,
  ) {
    return SchoolImportPagePayload(
      url: request.source.url,
      title: request.source.title,
      html: request.source.content,
      locale: request.locale,
      sourceHint: request.sourceHint,
    );
  }

  final String url;
  final String title;
  final String html;
  final String locale;
  final String? sourceHint;

  Map<String, dynamic> toJson() => {
    'url': url,
    'title': title,
    'html': html,
    'locale': locale,
    if (sourceHint != null && sourceHint!.trim().isNotEmpty)
      'sourceHint': sourceHint,
  };
}

class SchoolImportMeta {
  const SchoolImportMeta({
    required this.sourceUrl,
    required this.pageTitle,
    required this.parser,
    required this.warnings,
  });

  final String sourceUrl;
  final String pageTitle;
  final String parser;
  final List<String> warnings;

  factory SchoolImportMeta.fromJson(Map<String, dynamic> json) {
    return SchoolImportMeta(
      sourceUrl: _stringValue(json['sourceUrl']),
      pageTitle: _stringValue(json['pageTitle']),
      parser: _stringValue(json['parser']),
      warnings: _listValue(json['warnings'])
          .where((item) => item != null)
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
    );
  }
}

class ImportedPeriodTimeDraft {
  const ImportedPeriodTimeDraft({
    required this.index,
    required this.startMinutes,
    required this.endMinutes,
  });

  final int index;
  final int startMinutes;
  final int endMinutes;

  factory ImportedPeriodTimeDraft.fromJson(Map<String, dynamic> json) {
    return ImportedPeriodTimeDraft(
      index: _intValue(json['index']) ?? 1,
      startMinutes: _intValue(json['startMinutes']) ?? 0,
      endMinutes: _intValue(json['endMinutes']) ?? 0,
    );
  }
}

ImportedPeriodTimeDraft? _tryParseBundledPeriodTimeDraft(Object? value) {
  if (value is! Map) {
    return null;
  }
  final json = _asStringKeyedMap(value);
  final index = _intValue(json['index']);
  final startMinutes = _intValue(json['startMinutes']);
  final endMinutes = _intValue(json['endMinutes']);
  if (index == null || startMinutes == null || endMinutes == null) {
    return null;
  }
  if (index <= 0 || startMinutes < 0 || endMinutes <= startMinutes) {
    return null;
  }
  return ImportedPeriodTimeDraft(
    index: index,
    startMinutes: startMinutes,
    endMinutes: endMinutes,
  );
}

class ImportedPeriodTimeSetDraft {
  const ImportedPeriodTimeSetDraft({
    required this.name,
    required this.periodTimes,
  });

  final String name;
  final List<ImportedPeriodTimeDraft> periodTimes;

  factory ImportedPeriodTimeSetDraft.fromJson(Map<String, dynamic> json) {
    final periodTimes = <ImportedPeriodTimeDraft>[];
    for (final item in _listValue(json['periodTimes'])) {
      final parsed = _tryParseBundledPeriodTimeDraft(item);
      if (parsed != null) {
        periodTimes.add(parsed);
      }
    }
    return ImportedPeriodTimeSetDraft(
      name: _stringValue(json['name']),
      periodTimes: periodTimes,
    );
  }
}

class ImportedCourseDraft {
  const ImportedCourseDraft({
    required this.name,
    required this.teacher,
    required this.location,
    required this.dayOfWeek,
    required this.semesterWeeks,
    required this.periods,
    required this.startMinutes,
    required this.endMinutes,
    required this.credit,
    required this.remarks,
    required this.customFields,
  });

  final String name;
  final String teacher;
  final String location;
  final int dayOfWeek;
  final List<int> semesterWeeks;
  final List<int> periods;
  final int startMinutes;
  final int endMinutes;
  final double credit;
  final String remarks;
  final Map<String, dynamic> customFields;

  factory ImportedCourseDraft.fromJson(Map<String, dynamic> json) {
    return ImportedCourseDraft(
      name: _stringValue(json['name']),
      teacher: _stringValue(json['teacher']),
      location: _stringValue(json['location']),
      dayOfWeek: _intValue(json['dayOfWeek']) ?? 1,
      semesterWeeks: _positiveIntList(
        json['semesterWeeks'],
        maxValue: maxTimetableWeeks,
      ),
      periods: _positiveIntList(json['periods'], maxValue: 999),
      startMinutes: _intValue(json['startMinutes']) ?? 0,
      endMinutes: _intValue(json['endMinutes']) ?? 0,
      credit: _doubleValue(json['credit']) ?? 0,
      remarks: _stringValue(json['remarks']),
      customFields: _asStringKeyedMap(json['customFields']),
    );
  }
}

class SchoolImportTimetableDraft {
  const SchoolImportTimetableDraft({
    required this.name,
    required this.startDate,
    required this.totalWeeks,
    required this.periodTimeSet,
    required this.courses,
  });

  final String name;
  final DateTime startDate;
  final int totalWeeks;
  final ImportedPeriodTimeSetDraft periodTimeSet;
  final List<ImportedCourseDraft> courses;

  factory SchoolImportTimetableDraft.fromJson(Map<String, dynamic> json) {
    final startDateRaw = _stringValue(json['startDate']);
    return SchoolImportTimetableDraft(
      name: _stringValue(json['name']),
      startDate: tryParseStrictIsoDate(startDateRaw) ?? DateTime.now(),
      totalWeeks: _intValue(json['totalWeeks']) ?? 18,
      periodTimeSet: ImportedPeriodTimeSetDraft.fromJson(
        _asStringKeyedMap(json['periodTimeSet']),
      ),
      courses: _listValue(json['courses'])
          .map(_asStringKeyedMap)
          .where((item) => item.isNotEmpty)
          .map(ImportedCourseDraft.fromJson)
          .toList(),
    );
  }

  SchoolImportTimetableDraft copyWith({
    String? name,
    DateTime? startDate,
    int? totalWeeks,
    ImportedPeriodTimeSetDraft? periodTimeSet,
    List<ImportedCourseDraft>? courses,
  }) {
    return SchoolImportTimetableDraft(
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      totalWeeks: totalWeeks ?? this.totalWeeks,
      periodTimeSet: periodTimeSet ?? this.periodTimeSet,
      courses: courses ?? this.courses,
    );
  }
}

class SchoolImportResponse {
  const SchoolImportResponse({required this.meta, required this.timetable});

  final SchoolImportMeta meta;
  final SchoolImportTimetableDraft timetable;

  factory SchoolImportResponse.fromJson(Map<String, dynamic> json) {
    final ok = _boolValue(json['ok']);
    if (ok == null) {
      throw const FormatException('Import response format is invalid.');
    }
    if (!ok) {
      throw FormatException(_stringValue(json['message'], 'Import failed.'));
    }
    final rawTimetable = json['timetable'];
    if (rawTimetable is! Map) {
      throw const FormatException('Import response format is invalid.');
    }
    final timetableJson = _asStringKeyedMap(rawTimetable);
    if (!_hasTimetablePayload(timetableJson)) {
      throw const FormatException('Import response format is invalid.');
    }
    return SchoolImportResponse(
      meta: SchoolImportMeta.fromJson(_asStringKeyedMap(json['meta'])),
      timetable: SchoolImportTimetableDraft.fromJson(timetableJson),
    );
  }

  SchoolImportResponse copyWith({
    SchoolImportMeta? meta,
    SchoolImportTimetableDraft? timetable,
  }) {
    return SchoolImportResponse(
      meta: meta ?? this.meta,
      timetable: timetable ?? this.timetable,
    );
  }
}

class SchoolImportApplyRequest {
  const SchoolImportApplyRequest({
    required this.response,
    required this.mode,
    required this.importBundledPeriodTimeSet,
    this.targetPeriodTimeSetId,
  });

  final SchoolImportResponse response;
  final TimetableImportMode mode;
  final bool importBundledPeriodTimeSet;
  final String? targetPeriodTimeSetId;
}
