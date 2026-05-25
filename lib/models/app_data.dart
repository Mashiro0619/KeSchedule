import 'dart:convert';

import '../data/migrations/app_data_migrations.dart';
import '../l10n/app_locale.dart';
import '../utils/constants.dart';
import '../utils/localized_names.dart';
import '../utils/time_utils.dart';
import 'app_mode.dart';
import 'course_item.dart';
import 'general_schedule.dart';
import 'general_schedule_data.dart';
import 'student_mode_data.dart';
import 'timetable_data.dart';

const Symbol _keepNullable = #keep;

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

Map<String, dynamic> _decodeJsonObject(String source) {
  final decoded = jsonDecode(source);
  final object = _asStringKeyedMap(decoded);
  if (object == null) {
    throw const FormatException('JSON root must be an object.');
  }
  return object;
}

int? _tryDecodeInt(Object? value) {
  return value is num ? value.toInt() : null;
}

String _stringValue(Object? value, [String fallback = '']) {
  return value is String ? value : fallback;
}

String? _nullableStringValue(Object? value) {
  return value is String ? value : null;
}

List<dynamic> _listValue(Object? value) {
  return value is List ? value : const <dynamic>[];
}

class AppData {
  const AppData({
    required this.activeMode,
    required this.studentMode,
    required this.generalMode,
    this.localeCode = defaultLocaleCode,
    this.themeMode = defaultThemeMode,
    this.themeColorMode = defaultThemeColorMode,
    this.themeSeedColorValue = defaultThemeSeedColorValue,
    this.colorfulUiColorValues = const {},
    this.privacyPolicyAcceptedVersion,
    this.privacyPolicyAcceptedAtIso,
    this.ignoredUpdateVersion,
    this.availableUpdateVersion,
  });

  final AppMode activeMode;
  final StudentModeData studentMode;
  final GeneralScheduleData generalMode;
  final String localeCode;
  final String themeMode;
  final String themeColorMode;
  final int themeSeedColorValue;
  final Map<String, int> colorfulUiColorValues;
  final String? privacyPolicyAcceptedVersion;
  final String? privacyPolicyAcceptedAtIso;
  final String? ignoredUpdateVersion;
  final String? availableUpdateVersion;

  Map<String, dynamic> toJson() => {
    'schemaVersion': appDataCurrentSchemaVersion,
    'activeMode': activeMode.value,
    'studentMode': studentMode.toJson(),
    'generalMode': generalMode.toJson(),
    'localeCode': normalizeLocaleCode(localeCode),
    'themeMode': normalizeThemeMode(themeMode),
    'themeColorMode': normalizeThemeColorMode(themeColorMode),
    'themeSeedColorValue': themeSeedColorValue,
    'colorfulUiColorValues': colorfulUiColorValues,
    if (privacyPolicyAcceptedVersion != null)
      'privacyPolicyAcceptedVersion': privacyPolicyAcceptedVersion,
    if (privacyPolicyAcceptedAtIso != null)
      'privacyPolicyAcceptedAtIso': privacyPolicyAcceptedAtIso,
    if (ignoredUpdateVersion != null)
      'ignoredUpdateVersion': ignoredUpdateVersion,
    if (availableUpdateVersion != null)
      'availableUpdateVersion': availableUpdateVersion,
  };

  factory AppData.fromJson(Map<String, dynamic> json) {
    // Run schemaVersion migrations before any field decoding so legacy data
    // and future bumps are handled in one place instead of being scattered
    // across this fromJson body.
    final migrated = appDataMigrationRunner.run(json);

    final localeCode = normalizeLocaleCode(
      _stringValue(migrated['localeCode'], defaultLocaleCode),
    );

    // Detect legacy format: old flat keys exist and studentMode key is absent
    final isLegacy =
        migrated.containsKey('timetables') &&
        !migrated.containsKey('studentMode');

    final StudentModeData studentMode;
    final GeneralScheduleData generalMode;
    final AppMode activeMode;

    if (isLegacy) {
      // Migrate legacy flat JSON to nested StudentModeData
      studentMode = StudentModeData.fromJson(migrated, localeCode: localeCode);
      generalMode = GeneralScheduleData.fromJson(const {});
      activeMode = studentMode.timetables.isNotEmpty
          ? AppMode.student
          : AppMode.general;
    } else {
      studentMode = migrated.containsKey('studentMode')
          ? StudentModeData.fromJson(
              _asStringKeyedMap(migrated['studentMode']) ?? const {},
              localeCode: localeCode,
            )
          : StudentModeData.fromJson({}, localeCode: localeCode);
      generalMode = migrated.containsKey('generalMode')
          ? GeneralScheduleData.fromJson(
              _asStringKeyedMap(migrated['generalMode']) ?? const {},
            )
          : _buildDefaultGeneralMode();
      activeMode = parseAppMode(_nullableStringValue(migrated['activeMode']));
    }

    return AppData(
      activeMode: activeMode,
      studentMode: studentMode,
      generalMode: generalMode,
      localeCode: localeCode,
      themeMode: normalizeThemeMode(
        _stringValue(migrated['themeMode'], defaultThemeMode),
      ),
      themeColorMode: normalizeThemeColorMode(
        _stringValue(migrated['themeColorMode'], defaultThemeColorMode),
      ),
      themeSeedColorValue:
          _tryDecodeInt(migrated['themeSeedColorValue']) ??
          defaultThemeSeedColorValue,
      colorfulUiColorValues: decodeColorValueMap(
        migrated['colorfulUiColorValues'],
      ),
      privacyPolicyAcceptedVersion:
          _nullableStringValue(migrated['privacyPolicyAcceptedVersion']),
      privacyPolicyAcceptedAtIso:
          _nullableStringValue(migrated['privacyPolicyAcceptedAtIso']),
      ignoredUpdateVersion: _nullableStringValue(
        migrated['ignoredUpdateVersion'],
      ),
      availableUpdateVersion: _nullableStringValue(
        migrated['availableUpdateVersion'],
      ),
    );
  }

  AppData copyWith({
    AppMode? activeMode,
    StudentModeData? studentMode,
    GeneralScheduleData? generalMode,
    String? localeCode,
    String? themeMode,
    String? themeColorMode,
    int? themeSeedColorValue,
    Map<String, int>? colorfulUiColorValues,
    Object? privacyPolicyAcceptedVersion = _keepNullable,
    Object? privacyPolicyAcceptedAtIso = _keepNullable,
    Object? ignoredUpdateVersion = _keepNullable,
    Object? availableUpdateVersion = _keepNullable,
  }) {
    return AppData(
      activeMode: activeMode ?? this.activeMode,
      studentMode: studentMode ?? this.studentMode,
      generalMode: generalMode ?? this.generalMode,
      localeCode: normalizeLocaleCode(localeCode ?? this.localeCode),
      themeMode: normalizeThemeMode(themeMode ?? this.themeMode),
      themeColorMode: normalizeThemeColorMode(
        themeColorMode ?? this.themeColorMode,
      ),
      themeSeedColorValue: themeSeedColorValue ?? this.themeSeedColorValue,
      colorfulUiColorValues:
          colorfulUiColorValues ?? this.colorfulUiColorValues,
      privacyPolicyAcceptedVersion:
          identical(privacyPolicyAcceptedVersion, _keepNullable)
          ? this.privacyPolicyAcceptedVersion
          : privacyPolicyAcceptedVersion as String?,
      privacyPolicyAcceptedAtIso:
          identical(privacyPolicyAcceptedAtIso, _keepNullable)
          ? this.privacyPolicyAcceptedAtIso
          : privacyPolicyAcceptedAtIso as String?,
      ignoredUpdateVersion: identical(ignoredUpdateVersion, _keepNullable)
          ? this.ignoredUpdateVersion
          : ignoredUpdateVersion as String?,
      availableUpdateVersion: identical(availableUpdateVersion, _keepNullable)
          ? this.availableUpdateVersion
          : availableUpdateVersion as String?,
    );
  }

  String encode() => jsonEncode(toJson());

  factory AppData.decode(String source) {
    return AppData.fromJson(_decodeJsonObject(source));
  }
}

GeneralScheduleData _buildDefaultGeneralMode() {
  return GeneralScheduleData.createDefault();
}

// Import/Export support

class ImportExportEnvelope {
  const ImportExportEnvelope({
    required this.schema,
    required this.version,
    required this.data,
  });

  final String schema;
  final int version;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() => {
    'schema': schema,
    'version': version,
    'data': data,
  };

  factory ImportExportEnvelope.fromJson(Map<String, dynamic> json) {
    return ImportExportEnvelope(
      schema: _stringValue(json['schema']),
      version: _tryDecodeInt(json['version']) ?? 1,
      data: _asStringKeyedMap(json['data']) ?? const {},
    );
  }

  String encode() => jsonEncode(toJson());

  factory ImportExportEnvelope.decode(String source) {
    return ImportExportEnvelope.fromJson(_decodeJsonObject(source));
  }
}

void _ensureSupportedEnvelope(
  ImportExportEnvelope envelope, {
  required String expectedSchema,
  String localeCode = defaultLocaleCode,
}) {
  if (!isImportExportSchema(envelope.schema, expectedSchema)) {
    throw FormatException(
      importFileTypeMismatchMessage(localeCode: localeCode),
    );
  }
  if (envelope.version > importExportVersion) {
    throw FormatException(
      importFileVersionUnsupportedMessage(localeCode: localeCode),
    );
  }
}

bool isImportExportSchema(String schema, String expectedSchema) {
  if (schema == expectedSchema) {
    return true;
  }
  const legacyPrefix = 'KeSchedule-';
  const currentPrefix = 'Sked-';
  return expectedSchema.startsWith(currentPrefix) &&
      schema == expectedSchema.replaceFirst(currentPrefix, legacyPrefix);
}

String encodeAppDataEnvelope(AppData data) {
  return ImportExportEnvelope(
    schema: appDataSchema,
    version: importExportVersion,
    data: data.toJson(),
  ).encode();
}

String encodeTimetableDataEnvelope(TimetableExportData data) {
  return ImportExportEnvelope(
    schema: timetableDataSchema,
    version: importExportVersion,
    data: data.toJson(),
  ).encode();
}

String encodePeriodTimesEnvelope(List<CoursePeriodTime> periodTimes) {
  return ImportExportEnvelope(
    schema: periodTimesSchema,
    version: importExportVersion,
    data: {'periodTimes': periodTimes.map((item) => item.toJson()).toList()},
  ).encode();
}

List<CoursePeriodTime> decodePeriodTimesEnvelope(
  String source, {
  String localeCode = defaultLocaleCode,
}) {
  final envelope = ImportExportEnvelope.decode(source);
  _ensureSupportedEnvelope(
    envelope,
    expectedSchema: periodTimesSchema,
    localeCode: localeCode,
  );
  return _listValue(envelope.data['periodTimes'])
      .map(_asStringKeyedMap)
      .whereType<Map<String, dynamic>>()
      .map(CoursePeriodTime.fromJson)
      .toList();
}

AppData decodeAppDataEnvelope(
  String source, {
  String localeCode = defaultLocaleCode,
}) {
  final envelope = ImportExportEnvelope.decode(source);
  _ensureSupportedEnvelope(
    envelope,
    expectedSchema: appDataSchema,
    localeCode: localeCode,
  );
  return AppData.fromJson({...envelope.data, 'localeCode': localeCode});
}

TimetableExportData decodeTimetableDataEnvelope(
  String source, {
  String localeCode = defaultLocaleCode,
}) {
  final envelope = ImportExportEnvelope.decode(source);
  _ensureSupportedEnvelope(
    envelope,
    expectedSchema: timetableDataSchema,
    localeCode: localeCode,
  );
  return TimetableExportData.fromJson(envelope.data, localeCode: localeCode);
}

AppData buildInitialAppData(
  List<CoursePeriodTime> periodTimes, {
  String localeCode = defaultLocaleCode,
}) {
  final defaultSet = PeriodTimeSet(
    id: defaultPeriodTimeSetId,
    name: defaultPeriodTimeSetName(localeCode: localeCode),
    periodTimes: buildPeriodTimesForCount(
      periodTimes.isEmpty ? 1 : periodTimes.length,
      source: periodTimes,
    ),
  );

  return AppData(
    activeMode: AppMode.general,
    studentMode: StudentModeData(
      activeTimetableId: '',
      timetables: const [],
      periodTimeSets: [defaultSet],
    ),
    generalMode: GeneralScheduleData.createDefault(),
    localeCode: localeCode,
  );
}

enum GeneralScheduleImportMode { addAsNew, replaceActive }

class GeneralScheduleExportData {
  const GeneralScheduleExportData({required this.schedules});

  final List<GeneralSchedule> schedules;

  Map<String, dynamic> toJson() => {
    'schemaVersion': generalScheduleSchemaVersion,
    'schedules': schedules.map((s) => s.toJson()).toList(),
  };

  factory GeneralScheduleExportData.fromJson(Map<String, dynamic> json) {
    final raw = _listValue(json['schedules']);
    return GeneralScheduleExportData(
      schedules: raw
          .map(_asStringKeyedMap)
          .whereType<Map<String, dynamic>>()
          .map((s) => GeneralSchedule.fromJson(s).normalized())
          .toList(),
    );
  }
}

String encodeGeneralScheduleDataEnvelope(GeneralScheduleExportData data) {
  return ImportExportEnvelope(
    schema: generalScheduleDataSchema,
    version: importExportVersion,
    data: data.toJson(),
  ).encode();
}

GeneralScheduleExportData decodeGeneralScheduleDataEnvelope(
  String source, {
  String localeCode = defaultLocaleCode,
}) {
  final envelope = ImportExportEnvelope.decode(source);
  _ensureSupportedEnvelope(
    envelope,
    expectedSchema: generalScheduleDataSchema,
    localeCode: localeCode,
  );
  return GeneralScheduleExportData.fromJson(envelope.data);
}
