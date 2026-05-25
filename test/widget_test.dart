import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:sked/config/app_config.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart' as app_locale;
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/l10n/app_strings.dart';
import 'package:sked/main.dart' hide main;
import 'package:sked/models/school_import_models.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/home_screen.dart';
import 'package:sked/screens/general_schedule_home_screen.dart';
import 'package:sked/screens/school_html_import_page.dart';
import 'package:sked/screens/school_import_parser_settings_page.dart';
import 'package:sked/screens/settings_page.dart';
import 'package:sked/screens/theme_settings_page.dart';
import 'package:sked/services/school_import_api.dart';
import 'package:sked/services/update_service.dart';
import 'package:sked/widgets/course_details_sheet.dart';
import 'package:sked/widgets/course_editor_sheet.dart';
import 'package:sked/widgets/period_time_set_picker_dialog.dart';
import 'package:sked/widgets/school_web_import_result_sheet.dart';
import 'package:sked/widgets/timetable_entry.dart';
import 'package:sked/widgets/timetable_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// 测试专用 JSON 存储实现，避免污染真实用户目录。
class TestTimetableStorage implements TimetableStorage {
  TestTimetableStorage(this.file);

  final File file;

  @override
  Future<void> save(AppData data) async {
    await file.writeAsString(data.encode());
  }

  @override
  Future<StorageLoadResult> load() async {
    if (!await file.exists()) {
      return const StorageLoadResult.empty();
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return const StorageLoadResult.empty();
    }
    return StorageLoadResult(
      data: AppData.decode(content),
      recoveryStatus: RecoveryStatus.none,
    );
  }

  @override
  Future<String?> filePath() async => file.path;
}

/// 内存存储用于 widget 测试，避免依赖真实文件系统。
class MemoryTimetableStorage implements TimetableStorage {
  MemoryTimetableStorage({AppData? initialData})
    : _content = initialData?.encode();

  String? _content;

  @override
  Future<StorageLoadResult> load() async {
    if (_content == null || _content!.trim().isEmpty) {
      return const StorageLoadResult.empty();
    }
    return StorageLoadResult(
      data: AppData.decode(_content!),
      recoveryStatus: RecoveryStatus.none,
    );
  }

  @override
  Future<void> save(AppData data) async {
    _content = data.encode();
  }

  @override
  Future<String?> filePath() async => 'memory://KeSchedule-test';
}

class FakeSuccessUpdateService extends UpdateService {
  const FakeSuccessUpdateService(this.result);

  final UpdateCheckResult result;

  @override
  Future<UpdateCheckResult> checkForUpdates({Locale? preferredLocale}) async {
    return result;
  }
}

class FakeThrowingUpdateService extends UpdateService {
  const FakeThrowingUpdateService(this.error);

  final Object error;

  @override
  Future<UpdateCheckResult> checkForUpdates({Locale? preferredLocale}) async {
    throw error;
  }
}

class FakeSchoolImportApi extends SchoolImportApi {
  FakeSchoolImportApi({required this.onImport});

  final Future<SchoolImportApiResult> Function(
    SchoolImportPagePayload payload,
    SchoolImportParserSettings? parserSettings,
  )
  onImport;

  int callCount = 0;
  SchoolImportPagePayload? lastPayload;
  SchoolImportParserSettings? lastParserSettings;

  @override
  Future<SchoolImportApiResult> importCurrentPageWithRawResponse(
    SchoolImportPagePayload payload, {
    SchoolImportParserSettings? parserSettings,
  }) async {
    callCount += 1;
    lastPayload = payload;
    lastParserSettings = parserSettings;
    return onImport(payload, parserSettings);
  }

  @override
  Stream<SchoolImportStreamEvent> importCurrentPageStream(
    SchoolImportPagePayload payload, {
    SchoolImportParserSettings? parserSettings,
    http.Client? client,
  }) async* {
    callCount += 1;
    lastPayload = payload;
    lastParserSettings = parserSettings;
    final result = await onImport(payload, parserSettings);
    yield ParseDelta(result.rawBody);
    yield ParseDone(response: result.response);
  }
}

Widget _buildLocalizedApp(Widget child, {Locale locale = const Locale('zh')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

Future<BuildContext> _pumpUpdateHarness(
  WidgetTester tester, {
  required TimetableProvider provider,
  Locale locale = const Locale('zh'),
}) async {
  late BuildContext context;
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: _buildLocalizedApp(
        Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox.shrink();
          },
        ),
        locale: locale,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return context;
}

AppData _withSchoolImportSettings(SchoolImportParserSettings settings) {
  final data = _buildTestAppData();
  return data.copyWith(
    studentMode: data.studentMode.copyWith(
      schoolImportParserSettings: settings,
    ),
  );
}

AppData _buildTestAppData() {
  final periodTimes = buildDefaultPeriodTimes();
  final defaultSet = PeriodTimeSet(
    id: 'set1',
    name: '测试默认节次',
    periodTimes: periodTimes,
  );
  final shortSet = PeriodTimeSet(
    id: 'set2',
    name: '测试短节次',
    periodTimes: periodTimes.take(8).toList(),
  );
  final primaryTimetable = TimetableData(
    id: 'default',
    config: TimetableConfig(
      name: '测试课表A',
      startDate: DateTime(2026, 2, 23),
      totalWeeks: 18,
      periodTimeSetId: defaultSet.id,
    ),
    courses: [
      CourseItem(
        id: 'course1',
        name: '高等数学',
        teacher: '陈老师',
        location: 'A-201',
        dayOfWeek: 1,
        semesterWeeks: buildAllSemesterWeeks(18),
        periods: const [1, 2],
        startMinutes: periodTimes[0].startMinutes,
        endMinutes: periodTimes[1].endMinutes,
        timeRange: buildTimeRange(
          periodTimes[0].startMinutes,
          periodTimes[1].endMinutes,
        ),
        credit: 4,
        remarks: '记得带作业',
        customFields: const {'QQ群': '123456'},
      ),
    ],
  );
  final backupTimetable = TimetableData(
    id: 'backup',
    config: TimetableConfig(
      name: '测试课表B',
      startDate: DateTime(2026, 3, 2),
      totalWeeks: 16,
      periodTimeSetId: shortSet.id,
    ),
    courses: const [],
  );
  return AppData(
    activeMode: AppMode.student,
    studentMode: StudentModeData(
      activeTimetableId: primaryTimetable.id,
      timetables: [primaryTimetable, backupTimetable],
      periodTimeSets: [defaultSet, shortSet],
    ),
    generalMode: GeneralScheduleData.fromJson(const {}),
    privacyPolicyAcceptedVersion: '2026-04-20',
  );
}

Map<String, dynamic> _buildSchoolImportSuccessJson({
  String parser = 'official',
  String timetableName = 'Imported timetable',
  String startDate = '2026-02-23T00:00:00.000',
  String periodTimeSetName = 'Imported periods',
  List<Map<String, dynamic>>? periodTimes,
  Map<String, dynamic>? customFields,
}) {
  return {
    'ok': true,
    'meta': {
      'sourceUrl': 'https://example.com',
      'pageTitle': 'Import page',
      'parser': parser,
      'warnings': ['warning'],
    },
    'timetable': {
      'name': timetableName,
      'startDate': startDate,
      'totalWeeks': 18,
      'periodTimeSet': {
        'name': periodTimeSetName,
        'periodTimes':
            periodTimes ??
            [
              {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
            ],
      },
      'courses': [
        {
          'name': 'Calculus',
          'teacher': 'Teacher',
          'location': 'A-201',
          'dayOfWeek': 1,
          'semesterWeeks': [1, 2],
          'periods': [1],
          'startMinutes': 480,
          'endMinutes': 525,
          'credit': 0,
          'remarks': '',
          'customFields': customFields ?? {'qqGroup': '123456'},
        },
      ],
    },
  };
}

SchoolImportResponse _buildSchoolImportResponse({
  String parser = 'official',
  String timetableName = 'Imported timetable',
  String startDate = '2026-02-23T00:00:00.000',
  String periodTimeSetName = 'Imported periods',
  List<Map<String, dynamic>>? periodTimes,
  Map<String, dynamic>? customFields,
}) {
  return SchoolImportResponse.fromJson(
    _buildSchoolImportSuccessJson(
      parser: parser,
      timetableName: timetableName,
      startDate: startDate,
      periodTimeSetName: periodTimeSetName,
      periodTimes: periodTimes,
      customFields: customFields,
    ),
  );
}

void main() {
  group('课表 JSON 存储', () {
    test('示例数据可以正确编码和解码', () {
      final data = _buildTestAppData();
      final encoded = data.encode();
      final decoded = AppData.decode(encoded);

      expect(
        decoded.studentMode.activeTimetableId,
        data.studentMode.activeTimetableId,
      );
      expect(
        decoded.studentMode.timetables.length,
        data.studentMode.timetables.length,
      );
      expect(decoded.studentMode.timetables.first.config.name, '测试课表A');
    });

    test('旧 weekday 字段会兼容成 dayOfWeek，且周次默认为全学期语义', () {
      final legacyJson = {
        'id': 'legacy',
        'name': '旧数据课程',
        'teacher': '老师',
        'location': '教室',
        'weekday': 3,
        'periods': [1, 2],
        'startMinutes': 480,
        'endMinutes': 570,
        'timeRange': '08:00 - 09:30',
        'credit': 2,
        'remarks': '',
        'customFields': <String, dynamic>{},
      };
      final course = CourseItem.fromJson(legacyJson);

      expect(course.dayOfWeek, 3);
      expect(course.semesterWeeks, isEmpty);
      expect(course.toJson()['dayOfWeek'], 3);
      expect(course.toJson().containsKey('weekday'), isFalse);
    });

    test('时间段命中连续节次时能自动推导节次', () {
      final periods = buildDefaultPeriodTimes();
      final matched = matchPeriodsForTimeRange(
        periods,
        periods[0].startMinutes,
        periods[1].endMinutes,
      );

      expect(matched, [1, 2]);
    });

    test('时间段不命中节次时返回空列表', () {
      final periods = buildDefaultPeriodTimes();
      final matched = matchPeriodsForTimeRange(
        periods,
        periods[0].startMinutes + 5,
        periods[1].endMinutes,
      );

      expect(matched, isEmpty);
    });

    test('provider 会在首次加载时创建 JSON 文件并可再次读取', () async {
      final tempRoot = Directory.systemTemp.path;
      final file = File('$tempRoot/KeSchedule_provider_test.json');
      if (await file.exists()) {
        await file.delete();
      }
      addTearDown(() async {
        if (await file.exists()) {
          await file.delete();
        }
      });

      final firstProvider = TimetableProvider(
        storage: TestTimetableStorage(file),
        systemLocaleCodeResolver: () => 'zh',
      );
      await firstProvider.load();

      expect(await file.exists(), isTrue);
      expect(firstProvider.activeTimetable.config.name, '空课表');

      final secondProvider = TimetableProvider(
        storage: TestTimetableStorage(file),
        systemLocaleCodeResolver: () => 'zh',
      );
      await secondProvider.load();

      expect(secondProvider.timetables, isEmpty);
      expect(secondProvider.activeTimetable.config.name, '空课表');
    });

    test('首次启动语言检测会优先命中受支持语言', () {
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('zh', 'TW')),
        'zh-Hant',
      );
      expect(
        app_locale.resolveFirstLaunchLocaleCode(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ),
        'zh-Hant',
      );
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('zh', 'HK')),
        'zh-Hant',
      );
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('zh', 'CN')),
        'zh',
      );
      expect(app_locale.resolveFirstLaunchLocaleCode(const Locale('zh')), 'zh');
      expect(app_locale.resolveFirstLaunchLocaleCode(const Locale('en')), 'en');
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('en', 'US')),
        'en',
      );
    });

    test('首次启动语言检测对空值或不受支持语言回退英语或同语言匹配', () {
      expect(app_locale.resolveFirstLaunchLocaleCode(null), 'en');
      expect(app_locale.resolveFirstLaunchLocaleCode(const Locale('ja')), 'ja');
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('fr', 'CA')),
        'fr',
      );
      expect(app_locale.resolveFirstLaunchLocaleCode(const Locale('ru')), 'ru');
      expect(
        app_locale.resolveFirstLaunchLocaleCode(const Locale('tlh')),
        'en',
      );
    });

    test('中文系语言默认使用配置的更新接口', () {
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('zh')),
        isTrue,
      );
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('zh', 'CN')),
        isTrue,
      );
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('zh', 'TW')),
        isTrue,
      );
    });

    test('非中文系语言默认使用 GitHub 更新源', () {
      expect(prefersConfiguredUpdateSourceForLocale(null), isFalse);
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('en')),
        isFalse,
      );
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('ja')),
        isFalse,
      );
      expect(
        prefersConfiguredUpdateSourceForLocale(const Locale('fr')),
        isFalse,
      );
    });

    test('中文系主源格式错误时会回退到 GitHub', () async {
      PackageInfo.setMockInitialValues(
        appName: 'KeSchedule',
        packageName: 'com.mashiro.KeSchedule',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString() == AppConfig.updateVersionUrl) {
            return http.Response('{"version":""}', 200);
          }
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response(
              jsonEncode({
                'tag_name': 'v1.2.0',
                'html_url':
                    'https://github.com/Mashiro0619/KeSchedule/releases/tag/v1.2.0',
                'body': 'notes',
              }),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('zh'),
      );

      expect(result.remoteVersion, '1.2.0');
      expect(result.hasUpdate, isTrue);
    });

    test('非中文系主源格式错误时会回退到配置接口', () async {
      PackageInfo.setMockInitialValues(
        appName: 'KeSchedule',
        packageName: 'com.mashiro.KeSchedule',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );
      final service = UpdateService(
        client: MockClient((request) async {
          if (request.url.toString().contains('/releases/latest')) {
            return http.Response('{"tag_name":""}', 200);
          }
          if (request.url.toString() == AppConfig.updateVersionUrl) {
            return http.Response(
              jsonEncode({'version': '1.3.0', 'updateContent': 'notes'}),
              200,
            );
          }
          return http.Response('not found', 404);
        }),
      );

      final result = await service.checkForUpdates(
        preferredLocale: const Locale('en'),
      );

      expect(result.remoteVersion, '1.3.0');
      expect(result.hasUpdate, isTrue);
    });

    test('导入导出包装结构可以正确编码与解码', () {
      final data = _buildTestAppData();
      final encoded = encodeAppDataEnvelope(data);
      final decoded = decodeAppDataEnvelope(encoded);

      expect(
        decoded.studentMode.timetables.length,
        data.studentMode.timetables.length,
      );
      expect(
        decoded.studentMode.activeTimetableId,
        data.studentMode.activeTimetableId,
      );
    });

    test('provider 支持导入单课表和节次模板', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final exportedTimetable = provider.exportActiveTimetableJson();
      final originalCount = provider.timetables.length;
      await provider.importTimetableJson(
        exportedTimetable,
        mode: TimetableImportMode.addAsNew,
      );
      expect(provider.timetables.length, originalCount + 1);

      final exportedPeriodTimes = provider.exportActivePeriodTimesJson();
      final importedPeriodTimes = provider.importPeriodTimesJson(
        exportedPeriodTimes,
      );
      expect(
        importedPeriodTimes.length,
        provider.activePeriodTimeSet.periodTimes.length,
      );
      expect(importedPeriodTimes.first.index, 1);
    });

    test('provider 切换模式不会清空学生课表或通用日程', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final event = GeneralEvent(
        id: 'evt_general',
        title: '通用会议',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );

      await provider.switchMode(AppMode.general);
      await provider.saveGeneralEvent(event);
      await provider.switchMode(AppMode.student);

      expect(provider.isStudentMode, isTrue);
      expect(provider.activeTimetable.config.name, '测试课表A');
      expect(provider.activeGeneralSchedule.events.single.title, '通用会议');

      await provider.switchMode(AppMode.general);

      expect(provider.isGeneralMode, isTrue);
      expect(provider.activeTimetable.config.name, '测试课表A');
      expect(provider.activeGeneralSchedule.events.single.id, 'evt_general');
    });

    test('provider 支持通用日程事件增删和每周重复展开', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final oneTimeEvent = GeneralEvent(
        id: 'evt_one_time',
        title: '一次性事件',
        startDateTimeIso: '2026-05-22T09:00:00.000',
        endDateTimeIso: '2026-05-22T10:00:00.000',
      );
      final weeklyEvent = GeneralEvent(
        id: 'evt_weekly',
        title: '每周例会',
        startDateTimeIso: '2026-05-18T14:00:00.000',
        endDateTimeIso: '2026-05-18T15:00:00.000',
        recurrence: GeneralEventRecurrence.weekly,
        recurrenceEndDateIso: '2026-06-01',
      );

      await provider.saveGeneralEvent(oneTimeEvent);
      await provider.saveGeneralEvent(weeklyEvent);

      final firstWeek = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 5, 18),
        endExclusive: DateTime(2026, 5, 25),
      );
      expect(
        firstWeek.map((item) => item.event.id),
        containsAll(['evt_one_time', 'evt_weekly']),
      );

      final secondWeek = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 5, 25),
        endExclusive: DateTime(2026, 6, 1),
      );
      expect(secondWeek.map((item) => item.event.id), contains('evt_weekly'));
      expect(
        secondWeek.map((item) => item.event.id),
        isNot(contains('evt_one_time')),
      );

      await provider.deleteGeneralEvent('evt_one_time');

      expect(
        provider.activeGeneralSchedule.events.map((event) => event.id),
        isNot(contains('evt_one_time')),
      );
      expect(
        provider.activeGeneralSchedule.events.map((event) => event.id),
        contains('evt_weekly'),
      );
    });

    test('重命名通用日程不会删除已有事件', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final scheduleId = provider.activeGeneralSchedule.id;
      await provider.saveGeneralEvent(
        GeneralEvent(
          id: 'evt_keep',
          title: '保留事件',
          startDateTimeIso: '2026-05-22T09:00:00.000',
          endDateTimeIso: '2026-05-22T10:00:00.000',
        ),
      );
      await provider.renameGeneralSchedule(scheduleId, '重命名日程');

      expect(provider.activeGeneralSchedule.name, '重命名日程');
      expect(provider.activeGeneralSchedule.events.single.id, 'evt_keep');
    });

    test('weekly 事件不会在 recurrence end date 之后再生成 occurrence', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await provider.saveGeneralEvent(
        GeneralEvent(
          id: 'evt_end_test',
          title: '截止测试',
          startDateTimeIso: '2026-05-18T14:00:00.000',
          endDateTimeIso: '2026-05-18T15:00:00.000',
          recurrence: GeneralEventRecurrence.weekly,
          recurrenceEndDateIso: '2026-06-01',
        ),
      );

      // Recurrence ends on June 1; week containing June 8 should have no occurrence.
      final beyondEnd = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 6, 8),
        endExclusive: DateTime(2026, 6, 15),
      );
      expect(
        beyondEnd.map((item) => item.event.id),
        isNot(contains('evt_end_test')),
      );

      // Week containing the end date itself should include it.
      final onEnd = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 6, 1),
        endExclusive: DateTime(2026, 6, 8),
      );
      expect(onEnd.map((item) => item.event.id), contains('evt_end_test'));
    });

    test('weekly occurrence 保留原事件 duration', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await provider.saveGeneralEvent(
        GeneralEvent(
          id: 'evt_90min',
          title: '90分钟课程',
          startDateTimeIso: '2026-05-18T09:15:00.000',
          endDateTimeIso: '2026-05-18T10:45:00.000',
          recurrence: GeneralEventRecurrence.weekly,
        ),
      );

      final occurrences = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 5, 25),
        endExclusive: DateTime(2026, 6, 1),
      );
      expect(occurrences.length, 1);

      final duration = occurrences.first.end.difference(
        occurrences.first.start,
      );
      expect(duration.inMinutes, 90);
    });

    test('跨午夜 occurrence duration 正确', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final event = GeneralEvent(
        id: 'evt_overnight',
        title: '夜间事件',
        startDateTimeIso: '2026-05-22T23:00:00.000',
        endDateTimeIso: '2026-05-23T01:00:00.000',
      );

      await provider.saveGeneralEvent(event);

      final occurrences = provider.generalOccurrencesForRange(
        startInclusive: DateTime(2026, 5, 22),
        endExclusive: DateTime(2026, 5, 23),
      );
      expect(occurrences.length, 1);
      expect(
        occurrences.first.end.difference(occurrences.first.start).inMinutes,
        120,
      );
    });

    test('旧数据会迁移出独立节次时间集', () {
      final legacy = AppData.decode(
        jsonEncode({
          'activeTimetableId': 'legacy_table',
          'timetables': [
            {
              'id': 'legacy_table',
              'config': {
                'name': '旧课表',
                'startDate': '2026-02-23T00:00:00.000',
                'totalWeeks': 18,
                'dailyPeriods': 4,
                'periodTimes': buildDefaultPeriodTimes()
                    .take(4)
                    .map((item) => item.toJson())
                    .toList(),
              },
              'courses': [],
            },
          ],
        }),
      );

      expect(legacy.studentMode.periodTimeSets.length, 1);
      expect(
        legacy.studentMode.timetables.first.config.periodTimeSetId,
        isNotEmpty,
      );
      expect(legacy.studentMode.periodTimeSets.first.periodTimes.length, 4);
      expect(legacy.activeMode, AppMode.student);
    });

    test('共享节次时间集编辑会直接全局生效', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final currentSet = provider.activePeriodTimeSet;
      await provider.assignPeriodTimeSetToTimetable('backup', currentSet.id);
      await provider.updatePeriodTimeSet(
        currentSet.copyWith(
          name: '全局新节次',
          periodTimes: buildPeriodTimesForCount(
            14,
            source: currentSet.periodTimes,
          ),
        ),
      );

      expect(provider.periodTimeSetForId(currentSet.id)?.name, '全局新节次');
      expect(
        provider.periodTimesForTimetable(provider.timetables.first).length,
        14,
      );
      expect(
        provider.periodTimesForTimetable(provider.timetables.last).length,
        14,
      );
    });

    test('仍被引用的节次时间集不能删除', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      expect(
        () => provider.deletePeriodTimeSet(provider.activePeriodTimeSet.id),
        throwsA(isA<FormatException>()),
      );
    });

    test('删除最后一个课表后进入空状态数据', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: AppData(
            activeMode: AppMode.student,
            studentMode: StudentModeData(
              activeTimetableId: 'only',
              timetables: [
                TimetableData(
                  id: 'only',
                  config: TimetableConfig(
                    name: '唯一课表',
                    startDate: DateTime(2026, 2, 23),
                    totalWeeks: 18,
                    periodTimeSetId: 'set1',
                  ),
                  courses: const [],
                ),
              ],
              periodTimeSets: [
                PeriodTimeSet(
                  id: 'set1',
                  name: '默认节次',
                  periodTimes: buildPeriodTimesForCount(10),
                ),
              ],
            ),
            generalMode: GeneralScheduleData.fromJson(const {}),
          ),
        ),
      );
      await provider.load();
      await provider.deleteTimetable('only');

      expect(provider.activeTimetableOrNull, isNull);
      expect(provider.timetables, isEmpty);
    });

    test('节次数量可以超过默认模板长度并自动补齐', () {
      final periodTimes = buildPeriodTimesForCount(16);

      expect(periodTimes.length, 16);
      expect(periodTimes.last.index, 16);
      expect(
        periodTimes.last.endMinutes,
        greaterThan(periodTimes[11].endMinutes),
      );
    });

    test('当天课程结束后会命中第二天第一节课', () {
      final periodTimes = buildDefaultPeriodTimes();
      final timetable = TimetableData(
        id: 'table_next_day',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'today_course',
            name: '今天的课',
            teacher: '',
            location: '',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1, 2],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[1].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[1].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
          CourseItem(
            id: 'tomorrow_first',
            name: '明天第一节',
            teacher: '',
            location: '',
            dayOfWeek: 2,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      final target = currentOrNextCourseTargetFor(
        timetable: timetable,
        selectedWeek: 1,
        realCurrentWeek: 1,
        now: DateTime(2026, 2, 23, 22, 30),
      );

      expect(target?.week, 1);
      expect(target?.weekday, 2);
      expect(target?.courseId, 'tomorrow_first');
    });

    test('周日课程结束后会命中下周一第一节课', () {
      final periodTimes = buildDefaultPeriodTimes();
      final timetable = TimetableData(
        id: 'table_cross_week',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'next_week_monday',
            name: '下周一第一节',
            teacher: '',
            location: '',
            dayOfWeek: 1,
            semesterWeeks: const [2],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      final target = currentOrNextCourseTargetFor(
        timetable: timetable,
        selectedWeek: 2,
        realCurrentWeek: 1,
        now: DateTime(2026, 3, 1, 22, 30),
      );

      expect(target?.week, 2);
      expect(target?.weekday, 1);
      expect(target?.courseId, 'next_week_monday');
    });

    test('copyWith 可以显式清空更新状态字段', () {
      final data = _buildTestAppData().copyWith(
        ignoredUpdateVersion: '1.6.10',
        availableUpdateVersion: '1.6.10',
      );
      final cleared = data.copyWith(
        ignoredUpdateVersion: null,
        availableUpdateVersion: null,
      );

      expect(cleared.ignoredUpdateVersion, isNull);
      expect(cleared.availableUpdateVersion, isNull);
    });

    test('五彩缤纷主题字段可以正确编码解码并兼容旧数据默认值', () {
      final themed = _buildTestAppData();
      final customized = themed.copyWith(
        themeColorMode: themeColorModeColorful,
        studentMode: themed.studentMode.copyWith(
          colorfulCourseTextColorMode: colorfulCourseTextColorModeCustom,
          courseNameColorValues: const {'高等数学': 0xFF445566, '线性代数': 0xFF556677},
        ),
        colorfulUiColorValues: const {
          colorfulUiPrimaryKey: 0xFF112233,
          colorfulUiSecondaryKey: 0xFF223344,
          colorfulUiTertiaryKey: 0xFF334455,
          colorfulCourseTextColorKey: 0xFF556677,
        },
      );
      final decodedCustomized = AppData.decode(customized.encode());

      expect(decodedCustomized.themeColorMode, themeColorModeColorful);
      expect(
        decodedCustomized.studentMode.colorfulCourseTextColorMode,
        colorfulCourseTextColorModeCustom,
      );
      expect(
        decodedCustomized.colorfulUiColorValues[colorfulUiPrimaryKey],
        0xFF112233,
      );
      expect(
        decodedCustomized.colorfulUiColorValues[colorfulUiSecondaryKey],
        0xFF223344,
      );
      expect(
        decodedCustomized.colorfulUiColorValues[colorfulUiTertiaryKey],
        0xFF334455,
      );
      expect(
        decodedCustomized.colorfulUiColorValues[colorfulCourseTextColorKey],
        0xFF556677,
      );
      expect(
        decodedCustomized.studentMode.courseNameColorValues['高等数学'],
        0xFF445566,
      );
      expect(
        decodedCustomized.studentMode.courseNameColorValues['线性代数'],
        0xFF556677,
      );

      final legacy = AppData.decode(
        jsonEncode({
          'activeTimetableId': '',
          'timetables': const [],
          'periodTimeSets': [
            {
              'id': 'set1',
              'name': '默认节次',
              'periodTimes': [
                {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
              ],
            },
          ],
        }),
      );

      expect(legacy.themeColorMode, themeColorModeSingle);
      expect(
        legacy.studentMode.colorfulCourseTextColorMode,
        colorfulCourseTextColorModeAuto,
      );
      expect(legacy.colorfulUiColorValues, isEmpty);
      expect(legacy.studentMode.courseNameColorValues, isEmpty);
      expect(legacy.activeMode, AppMode.general);
    });

    test('描边设置字段可以正确编码解码并兼容旧数据默认值', () {
      final themed = _buildTestAppData();
      final customized = themed.copyWith(
        studentMode: themed.studentMode.copyWith(
          liveCourseOutlineEnabled: false,
          liveCourseOutlineFollowTheme: false,
          liveCourseOutlineCustomColorInitialized: true,
          liveCourseOutlineColorValue: 0xFF123456,
          liveCourseOutlineMode: liveCourseOutlineModeAllDisplayed,
          liveCourseOutlineWidth: 3.5,
        ),
      );
      final decodedCustomized = AppData.decode(customized.encode());

      expect(decodedCustomized.studentMode.liveCourseOutlineEnabled, isFalse);
      expect(
        decodedCustomized.studentMode.liveCourseOutlineFollowTheme,
        isFalse,
      );
      expect(
        decodedCustomized.studentMode.liveCourseOutlineCustomColorInitialized,
        isTrue,
      );
      expect(
        decodedCustomized.studentMode.liveCourseOutlineColorValue,
        0xFF123456,
      );
      expect(
        decodedCustomized.studentMode.liveCourseOutlineMode,
        liveCourseOutlineModeAllDisplayed,
      );
      expect(decodedCustomized.studentMode.liveCourseOutlineWidth, 3.5);

      final legacy = AppData.decode(
        jsonEncode({
          'activeTimetableId': '',
          'timetables': const [],
          'periodTimeSets': [
            {
              'id': 'set1',
              'name': '默认节次',
              'periodTimes': [
                {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
              ],
            },
          ],
        }),
      );

      expect(legacy.studentMode.liveCourseOutlineEnabled, isTrue);
      expect(legacy.studentMode.liveCourseOutlineFollowTheme, isTrue);
      expect(
        legacy.studentMode.liveCourseOutlineCustomColorInitialized,
        isFalse,
      );
      expect(
        legacy.studentMode.liveCourseOutlineMode,
        liveCourseOutlineModeCurrentOrNext,
      );
      expect(
        legacy.studentMode.liveCourseOutlineWidth,
        defaultLiveCourseOutlineWidth,
      );
      expect(legacy.activeMode, AppMode.general);
    });

    test('provider 更新描边模式后会持久化', () async {
      final storage = MemoryTimetableStorage(initialData: _buildTestAppData());
      final provider = TimetableProvider(storage: storage);
      await provider.load();

      await provider.updateLiveCourseOutlineSettings(
        enabled: provider.liveCourseOutlineEnabled,
        followTheme: provider.liveCourseOutlineFollowTheme,
        colorValue: provider.liveCourseOutlineColorValue,
        customColorInitialized:
            provider.liveCourseOutlineCustomColorInitialized,
        mode: liveCourseOutlineModeAllDisplayed,
        width: provider.liveCourseOutlineWidth,
      );

      expect(provider.liveCourseOutlineMode, liveCourseOutlineModeAllDisplayed);

      final reloaded = TimetableProvider(storage: storage);
      await reloaded.load();
      expect(reloaded.liveCourseOutlineMode, liveCourseOutlineModeAllDisplayed);
    });

    test('首次加载无本地数据时会按系统语言初始化英文', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(),
        systemLocaleCodeResolver: () => 'en',
      );
      await provider.load();

      expect(provider.localeCode, 'en');
      expect(provider.activePeriodTimeSet.name, 'Default periods');
    });

    test('非 UI 字符串助手会复用生成本地化内容', () {
      final zhStrings = AppStrings.forLocaleCode('zh');
      final zhHantStrings = AppStrings.forLocaleCode('zh-Hant');
      final enStrings = AppStrings.forLocaleCode('en');

      expect(zhStrings.defaultPeriodTimeSetName, '默认节次');
      expect(zhHantStrings.defaultPeriodTimeSetName, '預設節次');
      expect(enStrings.defaultPeriodTimeSetName, 'Default periods');
      expect(zhStrings.importedPeriodTimeSetName('测试课表'), '测试课表 节次');
      expect(zhHantStrings.importedPeriodTimeSetName('測試課表'), '測試課表 節次');
      expect(
        enStrings.importedPeriodTimeSetName('Test Timetable'),
        'Test Timetable periods',
      );
      expect(zhStrings.formatDayOfWeekLabel(1), '星期一');
      expect(zhHantStrings.formatDayOfWeekLabel(1), '星期一');
      expect(enStrings.formatDayOfWeekLabel(1), 'Monday');
      expect(zhStrings.formatWeekdayShortLabel(7), '日');
      expect(enStrings.formatWeekdayShortLabel(7), 'Sun');
      expect(zhStrings.formatMonthLabel(3), '3月');
      expect(enStrings.formatMonthLabel(3), 'Mar');
      expect(
        zhStrings.formatSemesterWeeksLabel(const [], totalWeeks: 18),
        '第 1-18 周',
      );
      expect(
        enStrings.formatSemesterWeeksLabel(const [], totalWeeks: 18),
        'Weeks 1-18',
      );
      expect(zhStrings.formatSemesterWeeksLabel(const [1, 2, 4]), '第 1-2、4 周');
      expect(
        enStrings.formatSemesterWeeksLabel(const [1, 2, 4]),
        'Weeks 1-2, 4',
      );
      expect(
        zhStrings.periodTimeSetInUseMessage(2),
        '该节次时间仍被 2 个课表使用，请先改关联再删除',
      );
      expect(
        enStrings.periodTimeSetInUseMessage(2),
        'This period time set is still used by 2 timetable(s). Reassign them before deleting.',
      );
    });

    test('locale helper 会标准化 code 并映射到受支持语言', () {
      expect(app_locale.normalizeLocaleCode('en_US'), 'en');
      expect(app_locale.normalizeLocaleCode('zh-Hant'), 'zh-Hant');
      expect(app_locale.normalizeLocaleCode('zh_TW'), 'zh-Hant');
      expect(app_locale.normalizeLocaleCode('zh-CN'), 'zh');
      expect(app_locale.normalizeLocaleCode('ja'), 'ja');
      expect(app_locale.appLocaleFromCode('en-US'), const Locale('en'));
      expect(
        app_locale.appLocaleFromCode('zh_TW'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      );
      expect(app_locale.languageLabelForLocaleCode('ja'), '日本語');
    });

    test('已有本地语言设置时不会被系统语言覆盖', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(localeCode: 'zh'),
        ),
        systemLocaleCodeResolver: () => 'en',
      );
      await provider.load();

      expect(provider.localeCode, 'zh');
    });

    test('导入课表后会自动生成课程颜色映射且同名课程共用同色', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final importData = TimetableExportData(
        timetables: [
          TimetableData(
            id: 'imported',
            config: TimetableConfig(
              name: '导入课表',
              startDate: DateTime(2026, 2, 23),
              totalWeeks: 18,
              periodTimeSetId: 'import_set',
            ),
            courses: [
              CourseItem(
                id: 'course_a1',
                name: '离散数学',
                teacher: '',
                location: '',
                dayOfWeek: 1,
                semesterWeeks: const [1],
                periods: const [1],
                startMinutes: 480,
                endMinutes: 525,
                timeRange: '08:00 - 08:45',
                credit: 0,
                remarks: '',
                customFields: const {},
              ),
              CourseItem(
                id: 'course_a2',
                name: '离散数学',
                teacher: '',
                location: '',
                dayOfWeek: 3,
                semesterWeeks: const [1],
                periods: const [2],
                startMinutes: 535,
                endMinutes: 580,
                timeRange: '08:55 - 09:40',
                credit: 0,
                remarks: '',
                customFields: const {},
              ),
              CourseItem(
                id: 'course_b',
                name: '大学物理',
                teacher: '',
                location: '',
                dayOfWeek: 2,
                semesterWeeks: const [1],
                periods: const [3],
                startMinutes: 600,
                endMinutes: 645,
                timeRange: '10:00 - 10:45',
                credit: 0,
                remarks: '',
                customFields: const {},
              ),
            ],
          ),
        ],
        periodTimeSets: [
          PeriodTimeSet(
            id: 'import_set',
            name: '导入节次',
            periodTimes: buildDefaultPeriodTimes(),
          ),
        ],
      );

      await provider.importSelectedTimetablesJson(
        encodeTimetableDataEnvelope(importData),
        timetableIds: const ['imported'],
        mode: TimetableImportMode.addAsNew,
      );

      expect(provider.courseNameColorValues['离散数学'], isNotNull);
      expect(provider.courseNameColorValues['大学物理'], isNotNull);
      expect(provider.courseNameColorValues.keys, contains('高等数学'));
      expect(
        provider.courseNameColorValues['离散数学'],
        isNot(provider.courseNameColorValues['大学物理']),
      );
    });

    test('再次导入时不会覆盖已有课程颜色但会为新课程补色', () async {
      final base = _buildTestAppData();
      final initialData = base.copyWith(
        studentMode: base.studentMode.copyWith(
          courseNameColorValues: const {'高等数学': 0xFF123456},
        ),
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: initialData),
      );
      await provider.load();

      final importData = TimetableExportData(
        timetables: [
          TimetableData(
            id: 'imported',
            config: TimetableConfig(
              name: '导入课表',
              startDate: DateTime(2026, 2, 23),
              totalWeeks: 18,
              periodTimeSetId: 'import_set',
            ),
            courses: [
              CourseItem(
                id: 'course_a',
                name: '高等数学',
                teacher: '',
                location: '',
                dayOfWeek: 1,
                semesterWeeks: const [1],
                periods: const [1],
                startMinutes: 480,
                endMinutes: 525,
                timeRange: '08:00 - 08:45',
                credit: 0,
                remarks: '',
                customFields: const {},
              ),
              CourseItem(
                id: 'course_b',
                name: '大学英语',
                teacher: '',
                location: '',
                dayOfWeek: 2,
                semesterWeeks: const [1],
                periods: const [2],
                startMinutes: 535,
                endMinutes: 580,
                timeRange: '08:55 - 09:40',
                credit: 0,
                remarks: '',
                customFields: const {},
              ),
            ],
          ),
        ],
        periodTimeSets: [
          PeriodTimeSet(
            id: 'import_set',
            name: '导入节次',
            periodTimes: buildDefaultPeriodTimes(),
          ),
        ],
      );

      await provider.importSelectedTimetablesJson(
        encodeTimetableDataEnvelope(importData),
        timetableIds: const ['imported'],
        mode: TimetableImportMode.addAsNew,
      );

      expect(provider.courseNameColorValues['高等数学'], 0xFF123456);
      expect(provider.courseNameColorValues['大学英语'], isNotNull);
      expect(provider.courseNameColorValues['大学英语'], isNot(0xFF123456));
    });

    test('加载旧数据时会自动拆开重复的默认课程配色', () async {
      final base = _buildTestAppData();
      final duplicatedDefaultColor = base.copyWith(
        studentMode: base.studentMode.copyWith(
          timetables: [
            TimetableData(
              id: 'default',
              config: TimetableConfig(
                name: '测试课表A',
                startDate: DateTime(2026, 2, 23),
                totalWeeks: 18,
                periodTimeSetId: 'set1',
              ),
              courses: [
                CourseItem(
                  id: 'course1',
                  name: '大学英语B1',
                  teacher: '',
                  location: '',
                  dayOfWeek: 1,
                  semesterWeeks: const [1],
                  periods: const [1],
                  startMinutes: 480,
                  endMinutes: 525,
                  timeRange: '08:00 - 08:45',
                  credit: 0,
                  remarks: '',
                  customFields: const {},
                ),
                CourseItem(
                  id: 'course2',
                  name: '大学语文',
                  teacher: '',
                  location: '',
                  dayOfWeek: 2,
                  semesterWeeks: const [1],
                  periods: const [1],
                  startMinutes: 480,
                  endMinutes: 525,
                  timeRange: '08:00 - 08:45',
                  credit: 0,
                  remarks: '',
                  customFields: const {},
                ),
              ],
            ),
          ],
          courseNameColorValues: const {
            '大学英语B1': 0xFFE57373,
            '大学语文': 0xFFE57373,
          },
        ),
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: duplicatedDefaultColor),
      );
      await provider.load();

      expect(provider.courseNameColorValues['大学英语B1'], 0xFFE57373);
      expect(provider.courseNameColorValues['大学语文'], isNotNull);
      expect(provider.courseNameColorValues['大学语文'], isNot(0xFFE57373));
    });

    test('跟随主题色的描边派生色会比旧实现更浅但仍深于原色', () {
      const seedColor = Color(0xFF6750A4);
      final derivedColor = deriveLiveCourseOutlineColorFromSeed(seedColor);
      final oldDerivedColor = HSLColor.fromColor(seedColor)
          .withLightness(
            (HSLColor.fromColor(seedColor).lightness - 0.16)
                .clamp(0.18, 0.72)
                .toDouble(),
          )
          .withSaturation(
            (HSLColor.fromColor(seedColor).saturation + 0.08)
                .clamp(0.12, 1.0)
                .toDouble(),
          )
          .toColor();
      final derivedHsl = HSLColor.fromColor(derivedColor);
      final seedHsl = HSLColor.fromColor(seedColor);
      final oldDerivedHsl = HSLColor.fromColor(oldDerivedColor);

      expect(derivedHsl.lightness, lessThan(seedHsl.lightness));
      expect(derivedHsl.lightness, greaterThan(oldDerivedHsl.lightness));
    });
  });

  group('课表解析设置', () {
    test('课表解析设置字段可以正确编码解码并兼容旧数据默认值', () {
      final themed = _buildTestAppData();
      final customized = themed.copyWith(
        studentMode: themed.studentMode.copyWith(
          schoolImportParserSettings: const SchoolImportParserSettings(
            source: schoolImportParserSourceCustomOpenAi,
            customBaseUrl: 'https://api.example.com/v1',
            customApiKey: 'sk-test',
            customModel: 'gpt-4.1-mini',
            customPrompt: 'Keep teacher names when available.',
          ),
        ),
      );
      final decodedCustomized = AppData.decode(customized.encode());

      expect(
        decodedCustomized.studentMode.schoolImportParserSettings.source,
        schoolImportParserSourceCustomOpenAi,
      );
      expect(
        decodedCustomized.studentMode.schoolImportParserSettings.customBaseUrl,
        'https://api.example.com/v1',
      );
      expect(
        decodedCustomized.studentMode.schoolImportParserSettings.customApiKey,
        'sk-test',
      );
      expect(
        decodedCustomized.studentMode.schoolImportParserSettings.customModel,
        'gpt-4.1-mini',
      );
      expect(
        decodedCustomized.studentMode.schoolImportParserSettings.customPrompt,
        'Keep teacher names when available.',
      );

      final legacy = AppData.decode(
        jsonEncode({
          'activeTimetableId': '',
          'timetables': const [],
          'periodTimeSets': [
            {
              'id': 'set1',
              'name': '默认节次',
              'periodTimes': [
                {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
              ],
            },
          ],
        }),
      );

      expect(
        legacy.studentMode.schoolImportParserSettings.source,
        schoolImportParserSourceOfficial,
      );
      expect(
        legacy.studentMode.schoolImportParserSettings.customBaseUrl,
        isEmpty,
      );
      expect(
        legacy.studentMode.schoolImportParserSettings.customApiKey,
        isEmpty,
      );
      expect(
        legacy.studentMode.schoolImportParserSettings.customModel,
        isEmpty,
      );
      expect(
        legacy.studentMode.schoolImportParserSettings.customPrompt,
        isEmpty,
      );
      expect(legacy.activeMode, AppMode.general);
    });

    test('provider 更新课表解析设置后会持久化且切回官方不清空自定义配置', () async {
      final storage = MemoryTimetableStorage(initialData: _buildTestAppData());
      final provider = TimetableProvider(storage: storage);
      await provider.load();

      await provider.updateSchoolImportParserSource(
        schoolImportParserSourceCustomOpenAi,
      );
      await provider.updateCustomSchoolImportBaseUrl(
        'https://api.example.com/v1',
      );
      await provider.updateCustomSchoolImportApiKey('sk-test');
      await provider.updateCustomSchoolImportModel('gpt-4.1-mini');
      await provider.updateCustomSchoolImportPrompt(
        'Prefer preserving original location text.',
      );
      await provider.updateSchoolImportParserSource(
        schoolImportParserSourceOfficial,
      );

      expect(
        provider.schoolImportParserSource,
        schoolImportParserSourceOfficial,
      );
      expect(provider.customSchoolImportBaseUrl, 'https://api.example.com/v1');
      expect(provider.customSchoolImportApiKey, 'sk-test');
      expect(provider.customSchoolImportModel, 'gpt-4.1-mini');
      expect(
        provider.customSchoolImportPrompt,
        'Prefer preserving original location text.',
      );

      final reloaded = TimetableProvider(storage: storage);
      await reloaded.load();
      expect(
        reloaded.schoolImportParserSource,
        schoolImportParserSourceOfficial,
      );
      expect(reloaded.customSchoolImportBaseUrl, 'https://api.example.com/v1');
      expect(reloaded.customSchoolImportApiKey, 'sk-test');
      expect(reloaded.customSchoolImportModel, 'gpt-4.1-mini');
      expect(
        reloaded.customSchoolImportPrompt,
        'Prefer preserving original location text.',
      );
    });

    test('SchoolImportApi 官方分支继续请求旧接口地址', () async {
      late Uri capturedUri;
      late Map<String, dynamic> capturedBody;
      final api = SchoolImportApi(
        client: MockClient((request) async {
          capturedUri = request.url;
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode(_buildSchoolImportSuccessJson()),
            200,
          );
        }),
      );

      final result = await api.importCurrentPageWithRawResponse(
        const SchoolImportPagePayload(
          url: 'https://example.com/page',
          title: 'Import page',
          html: '<html></html>',
          locale: 'zh',
          sourceHint: 'official',
        ),
      );

      expect(capturedUri.path, endsWith('/api.php'));
      expect(capturedUri.queryParameters['action'], 'import_timetable');
      expect(capturedBody['sourceHint'], 'official');
      expect(capturedBody.containsKey('customPrompt'), isFalse);
      expect(result.response.meta.parser, 'official');
      expect(
        result.response.timetable.courses.first.customFields['qqGroup'],
        '123456',
      );
    });

    test('SchoolImportApi 自定义分支会解析聊天响应并补全 parser 元信息', () async {
      late Uri capturedUri;
      late Map<String, dynamic> capturedBody;
      late Map<String, String> capturedHeaders;
      final api = SchoolImportApi(
        client: MockClient((request) async {
          capturedUri = request.url;
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          capturedHeaders = request.headers;
          return http.Response(
            jsonEncode({
              'choices': [
                {
                  'message': {
                    'content': jsonEncode(
                      _buildSchoolImportSuccessJson(parser: ''),
                    ),
                  },
                },
              ],
            }),
            200,
          );
        }),
      );

      final result = await api.importCurrentPageWithRawResponse(
        const SchoolImportPagePayload(
          url: 'https://example.com/page',
          title: 'Import page',
          html: '<html></html>',
          locale: 'zh',
          sourceHint: schoolImportParserSourceCustomOpenAi,
        ),
        parserSettings: const SchoolImportParserSettings(
          source: schoolImportParserSourceCustomOpenAi,
          customBaseUrl: 'https://api.example.com/v1',
          customApiKey: 'sk-test',
          customModel: 'gpt-4.1-mini',
          customPrompt: 'You are a custom parser. Return JSON only.',
        ),
      );

      expect(capturedUri.path, '/v1/chat/completions');
      expect(capturedHeaders['authorization'], 'Bearer sk-test');
      expect(capturedBody['model'], 'gpt-4.1-mini');
      expect(capturedBody['response_format']['type'], 'json_object');
      final messages = capturedBody['messages'] as List<dynamic>;
      final systemPrompt =
          (messages.first as Map<String, dynamic>)['content'] as String;
      expect(systemPrompt, 'You are a custom parser. Return JSON only.');
      expect(result.response.meta.parser, 'custom-openai:gpt-4.1-mini');
      expect(
        result.response.timetable.courses.first.customFields['qqGroup'],
        '123456',
      );
    });

    test('SchoolImportApi 可获取并排序去重模型列表', () async {
      final api = SchoolImportApi(
        client: MockClient((request) async {
          expect(request.url.path, '/v1/models');
          expect(request.headers['authorization'], 'Bearer sk-test');
          return http.Response(
            jsonEncode({
              'data': [
                {'id': 'z-model'},
                {'id': 'a-model'},
                {'id': 'z-model'},
              ],
            }),
            200,
          );
        }),
      );

      final models = await api.fetchCustomModels(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'sk-test',
      );

      expect(models, ['a-model', 'z-model']);
    });

    testWidgets('课表解析设置页在自定义模式显示 Base URL API 密钥 模型和获取模型列表按钮', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
              customPrompt: 'Keep original course names.',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolImportParserSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('课表解析设置'), findsOneWidget);
      expect(find.text('Base URL'), findsOneWidget);
      expect(find.text('API 密钥'), findsOneWidget);
      expect(find.text('模型名称'), findsOneWidget);
      expect(find.text('获取模型列表'), findsOneWidget);
      expect(find.textContaining('gpt-4.1-mini'), findsOneWidget);
      final customPromptTitle = find.text('自定义提示词');
      expect(customPromptTitle, findsOneWidget);
      expect(find.text('Keep original course names.'), findsNothing);
      await tester.ensureVisible(customPromptTitle);
      await tester.pumpAndSettle();
      await tester.tap(customPromptTitle);
      await tester.pumpAndSettle();
      expect(find.text('Keep original course names.'), findsOneWidget);
      expect(find.textContaining('仅对自定义 OpenAI 兼容接口生效'), findsOneWidget);
    });

    test('SchoolImportApi 自定义分支在未保存自定义提示词时使用内置提示词', () async {
      late Map<String, dynamic> capturedBody;
      final api = SchoolImportApi(
        client: MockClient((request) async {
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({
              'choices': [
                {
                  'message': {
                    'content': jsonEncode(
                      _buildSchoolImportSuccessJson(parser: ''),
                    ),
                  },
                },
              ],
            }),
            200,
          );
        }),
      );

      await api.importCurrentPageWithRawResponse(
        const SchoolImportPagePayload(
          url: 'https://example.com/page',
          title: 'Import page',
          html: '<html></html>',
          locale: 'zh',
          sourceHint: schoolImportParserSourceCustomOpenAi,
        ),
        parserSettings: const SchoolImportParserSettings(
          source: schoolImportParserSourceCustomOpenAi,
          customBaseUrl: 'https://api.example.com/v1',
          customApiKey: 'sk-test',
          customModel: 'gpt-4.1-mini',
        ),
      );

      final messages = capturedBody['messages'] as List<dynamic>;
      final systemPrompt =
          (messages.first as Map<String, dynamic>)['content'] as String;
      expect(systemPrompt, SchoolImportApi.defaultCustomOpenAiSystemPrompt);
    });

    testWidgets('官方模式不显示自定义提示词编辑器', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolImportParserSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('自定义提示词'), findsNothing);
    });

    testWidgets('自定义提示词可重置为默认提示词', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
              customPrompt: 'Only keep course name and weekday.',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolImportParserSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final customPromptTitle = find.text('自定义提示词');
      await tester.ensureVisible(customPromptTitle);
      await tester.pumpAndSettle();
      await tester.tap(customPromptTitle);
      await tester.pumpAndSettle();

      expect(
        provider.customSchoolImportPrompt,
        'Only keep course name and weekday.',
      );
      final resetPromptButton = find.text('重置默认提示词');
      expect(resetPromptButton, findsOneWidget);
      await tester.ensureVisible(resetPromptButton);
      await tester.pumpAndSettle();
      await tester.tap(resetPromptButton);
      await tester.pumpAndSettle();

      expect(provider.customSchoolImportPrompt, isEmpty);
      final textField = tester.widget<TextField>(find.byType(TextField).last);
      expect(
        textField.controller?.text,
        SchoolImportApi.defaultCustomOpenAiSystemPrompt,
      );
    });

    testWidgets('解析页可跳转到课表解析设置页且标题显示为解析', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolHtmlImportPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('解析课表页面内容'), findsOneWidget);
      expect(find.text('课表解析设置'), findsOneWidget);

      await tester.tap(find.text('课表解析设置'));
      await tester.pumpAndSettle();

      expect(find.text('课表解析设置'), findsWidgets);
      expect(find.text('Base URL'), findsOneWidget);
    });

    testWidgets('设置页语言入口会进入独立页面并更新 provider', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(localeCode: 'en'),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('英语'), findsOneWidget);

      await tester.tap(find.text('语言'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchBar), findsNothing);
      expect(find.text('简体中文'), findsOneWidget);
      expect(find.text('繁体中文'), findsOneWidget);
      expect(find.text('英语'), findsWidgets);
      expect(find.text('意大利语'), findsOneWidget);
      expect(find.text('葡萄牙语'), findsOneWidget);
      expect(find.text('俄语'), findsOneWidget);
      expect(find.text('日语'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(SearchBar), findsOneWidget);

      final simplifiedChineseOption = find.text('简体中文').last;
      await tester.ensureVisible(simplifiedChineseOption);
      await tester.pumpAndSettle();
      await tester.tap(simplifiedChineseOption);
      await tester.pumpAndSettle();

      expect(provider.localeCode, 'zh');
      expect(find.text('简体中文'), findsOneWidget);
    });

    testWidgets('设置-导入导出数据中可进入解析课表页面', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final dataImportExportTile = find.text('导入导出数据');
      await tester.ensureVisible(dataImportExportTile);
      await tester.pumpAndSettle();
      await tester.tap(dataImportExportTile);
      await tester.pumpAndSettle();

      final schoolHtmlImportEntry = find.text('粘贴课程表页面内容导入');
      expect(schoolHtmlImportEntry, findsOneWidget);
      await tester.ensureVisible(schoolHtmlImportEntry);
      await tester.pumpAndSettle();
      await tester.tap(schoolHtmlImportEntry);
      await tester.pumpAndSettle();

      expect(find.text('解析课表页面内容'), findsOneWidget);
      expect(find.text('课表解析设置'), findsOneWidget);
    });

    testWidgets(
      'general import/export actions are scrollable on small screens',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(360, 420));
        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
        });
        final provider = TimetableProvider(
          storage: MemoryTimetableStorage(
            initialData: _buildTestAppData().copyWith(
              activeMode: AppMode.general,
            ),
          ),
        );
        await provider.load();

        await tester.pumpWidget(
          ChangeNotifierProvider<TimetableProvider>.value(
            value: provider,
            child: const MaterialApp(
              locale: Locale('en'),
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final generalImportExportTile = find.text('Schedule import & export');
        await tester.ensureVisible(generalImportExportTile);
        await tester.pumpAndSettle();
        await tester.tap(generalImportExportTile);
        await tester.pumpAndSettle();

        expect(find.text('Import JSON file'), findsOneWidget);
        expect(find.text('Import ICS file'), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text('Copy ICS'),
          160,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.pumpAndSettle();

        expect(find.text('Copy ICS'), findsOneWidget);
      },
    );

    testWidgets('HTML 导入页在自定义解析配置不完整时显示跳转配置页按钮', (tester) async {
      final incompleteProvider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: '',
              customApiKey: '',
              customModel: '',
            ),
          ),
        ),
      );
      await incompleteProvider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: incompleteProvider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolHtmlImportPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('自定义解析配置不完整'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, '课表解析设置'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, '课表解析设置'));
      await tester.pumpAndSettle();

      expect(find.text('课表解析设置'), findsWidgets);
      expect(find.text('Base URL'), findsOneWidget);
    });

    testWidgets('HTML 导入页会区分自定义配置缺失与完整状态', (tester) async {
      final incompleteProvider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: '',
              customApiKey: '',
              customModel: '',
            ),
          ),
        ),
      );
      await incompleteProvider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: incompleteProvider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolHtmlImportPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('自定义解析配置不完整'), findsOneWidget);

      final completeProvider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
              customPrompt: 'Keep the original page title when present.',
            ),
          ),
        ),
      );
      await completeProvider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: completeProvider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolHtmlImportPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('解析并导入'), findsOneWidget);
      expect(find.textContaining('gpt-4.1-mini'), findsOneWidget);
    });

    test('网页解析导入会保留 customFields 并导入内含节次时间集', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final response = _buildSchoolImportResponse(
        periodTimes: const [
          {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
          {'index': 2, 'startMinutes': 530, 'endMinutes': 575},
        ],
        customFields: const {'课程群': '654321'},
      );

      final beforeSetCount = provider.periodTimeSets.length;
      await provider.applySchoolImportRequest(
        SchoolImportApplyRequest(
          response: response,
          mode: TimetableImportMode.addAsNew,
          importBundledPeriodTimeSet: true,
        ),
      );

      expect(provider.periodTimeSets.length, beforeSetCount + 1);
      expect(provider.activeTimetable.config.name, 'Imported timetable');
      expect(provider.activeTimetable.config.startDate, DateTime(2026, 2, 23));
      expect(
        provider.activeTimetable.courses.first.customFields['课程群'],
        '654321',
      );
      expect(provider.activePeriodTimeSet.periodTimes.length, 2);
      expect(provider.activePeriodTimeSet.name, 'Imported periods');
    });

    test('网页解析导入丢弃内含节次时会复用现有节次时间集', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final beforeSetIds = provider.periodTimeSets
          .map((item) => item.id)
          .toList();
      await provider.applySchoolImportRequest(
        SchoolImportApplyRequest(
          response: _buildSchoolImportResponse(),
          mode: TimetableImportMode.addAsNew,
          importBundledPeriodTimeSet: false,
          targetPeriodTimeSetId: 'set2',
        ),
      );

      expect(
        provider.periodTimeSets.map((item) => item.id).toList(),
        beforeSetIds,
      );
      expect(provider.activeTimetable.config.periodTimeSetId, 'set2');
    });

    test('网页解析导入覆盖当前课表时也能导入内含节次时间集', () async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      final currentId = provider.activeTimetable.id;
      final beforeSetCount = provider.periodTimeSets.length;
      await provider.applySchoolImportRequest(
        SchoolImportApplyRequest(
          response: _buildSchoolImportResponse(
            timetableName: 'Replaced timetable',
            customFields: const {'备注': '覆盖导入'},
          ),
          mode: TimetableImportMode.replaceActive,
          importBundledPeriodTimeSet: true,
        ),
      );

      expect(provider.activeTimetable.id, currentId);
      expect(provider.activeTimetable.config.name, 'Replaced timetable');
      expect(provider.activeTimetable.courses.first.customFields['备注'], '覆盖导入');
      expect(provider.periodTimeSets.length, beforeSetCount + 1);
    });

    testWidgets('网页解析导入结果页默认显示解析结果中的开学时间并允许切换节次时间集策略', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();
      final response = _buildSchoolImportResponse(
        startDate: '2026-03-09T00:00:00.000',
        periodTimes: const [
          {'index': 1, 'startMinutes': 480, 'endMinutes': 525},
          {'index': 2, 'startMinutes': 530, 'endMinutes': 575},
        ],
      );
      SchoolImportApplyRequest? sheetResult;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    sheetResult =
                        await showModalBottomSheet<SchoolImportApplyRequest>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => SchoolWebImportResultSheet(
                            response: response,
                            canReplaceCurrent: true,
                            periodTimeSets: provider.periodTimeSets,
                            initialPeriodTimeSetId:
                                provider.activePeriodTimeSet.id,
                            provider: provider,
                          ),
                        );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('2026-03-09'), findsOneWidget);
      expect(find.text('导入并关联'), findsOneWidget);
      expect(find.text('丢弃内含节次'), findsOneWidget);

      await tester.tap(find.text('丢弃内含节次'));
      await tester.pumpAndSettle();

      expect(find.text('选择节次时间集'), findsOneWidget);

      final importAsNewText = find.text('作为新课表导入');
      await tester.ensureVisible(importAsNewText);
      await tester.pump();
      await tester.tap(importAsNewText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(sheetResult, isNotNull);
      expect(sheetResult!.importBundledPeriodTimeSet, isFalse);
      expect(
        sheetResult!.targetPeriodTimeSetId,
        provider.activePeriodTimeSet.id,
      );
    });

    testWidgets('网页解析导入结果页在没有现有节次时间集时禁用丢弃内含节次', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();
      final response = _buildSchoolImportResponse();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SchoolWebImportResultSheet(
              response: response,
              canReplaceCurrent: true,
              periodTimeSets: const [],
              initialPeriodTimeSetId: '',
              provider: provider,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final discardChoice = find.text('丢弃内含节次');
      expect(discardChoice, findsOneWidget);
      await tester.tap(discardChoice);
      await tester.pumpAndSettle();
      expect(find.text('选择节次时间集'), findsNothing);
      expect(find.textContaining('当前没有可用节次时间集'), findsOneWidget);
    });

    testWidgets('HTML 导入页在请求进行中会禁用重复提交并只请求一次', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
          ),
        ),
      );
      await provider.load();
      final completer = Completer<SchoolImportApiResult>();
      final fakeApi = FakeSchoolImportApi(onImport: (_, _) => completer.future);

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: SchoolHtmlImportPage(api: fakeApi),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '<table>demo</table>');
      await tester.pump();
      await tester.tap(find.widgetWithIcon(FilledButton, Icons.compress));
      await tester.pumpAndSettle();

      final submitButtonFinder = find.widgetWithText(FilledButton, '解析并导入');
      await tester.ensureVisible(submitButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(submitButtonFinder, warnIfMissed: false);
      await tester.tap(submitButtonFinder, warnIfMissed: false);
      await tester.pump();

      expect(fakeApi.callCount, 1);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(2));

      completer.complete(
        SchoolImportApiResult(
          response: _buildSchoolImportResponse(),
          rawBody: jsonEncode(_buildSchoolImportSuccessJson()),
          statusCode: 200,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final confirmText = find.text('确定');
      await tester.ensureVisible(confirmText);
      await tester.pump();
      await tester.tap(confirmText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final cancelText = find.text('取消');
      await tester.ensureVisible(cancelText);
      await tester.pump();
      await tester.tap(cancelText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    });

    testWidgets('HTML 导入页成功后会把导入结果写入 provider', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _withSchoolImportSettings(
            const SchoolImportParserSettings(
              source: schoolImportParserSourceCustomOpenAi,
              customBaseUrl: 'https://api.example.com/v1',
              customApiKey: 'sk-test',
              customModel: 'gpt-4.1-mini',
            ),
          ),
        ),
      );
      await provider.load();
      final fakeApi = FakeSchoolImportApi(
        onImport: (_, _) async => SchoolImportApiResult(
          response: _buildSchoolImportResponse(
            timetableName: 'Widget imported timetable',
            customFields: const {'来源': 'widget-test'},
          ),
          rawBody: jsonEncode(
            _buildSchoolImportSuccessJson(
              timetableName: 'Widget imported timetable',
              customFields: const {'来源': 'widget-test'},
            ),
          ),
          statusCode: 200,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('zh'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ChangeNotifierProvider<TimetableProvider>.value(
                            value: provider,
                            child: SchoolHtmlImportPage(api: fakeApi),
                          ),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '<table>demo</table>');
      await tester.pump();
      final compressButton = find.widgetWithIcon(FilledButton, Icons.compress);
      await tester.ensureVisible(compressButton);
      await tester.pumpAndSettle();
      await tester.tap(compressButton);
      await tester.pumpAndSettle();
      final submitButton = find.widgetWithText(FilledButton, '解析并导入');
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      final confirmText = find.text('确定');
      await tester.ensureVisible(confirmText);
      await tester.pump();
      await tester.tap(confirmText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      final importAsNewText = find.text('作为新课表导入');
      await tester.ensureVisible(importAsNewText);
      await tester.pump();
      await tester.tap(importAsNewText);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(fakeApi.callCount, 1);
      expect(provider.activeTimetable.config.name, 'Widget imported timetable');
      expect(
        provider.activeTimetable.courses.first.customFields['来源'],
        'widget-test',
      );
      expect(provider.periodTimeSets.length, 3);
      expect(provider.activePeriodTimeSet.name, 'Imported periods');
    });
  });

  group('节次时间集选择', () {
    testWidgets('当前选择的节次时间集不显示勾选图标', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: FilledButton(
                    onPressed: () {
                      showPeriodTimeSetPickerDialog(
                        context,
                        provider: provider,
                        selectedPeriodTimeSetId:
                            provider.activePeriodTimeSet.id,
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('选择节次时间集'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    });
  });

  group('课表显示设置', () {
    testWidgets('关闭跟随主题色时会初始化自定义描边颜色', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('课程描边'), 200);
      await tester.tap(find.text('课程描边'));
      await tester.pumpAndSettle();

      expect(provider.liveCourseOutlineFollowTheme, isTrue);
      expect(provider.liveCourseOutlineCustomColorInitialized, isFalse);

      await tester.tap(find.widgetWithText(SwitchListTile, '跟随主题色'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(provider.liveCourseOutlineFollowTheme, isFalse);
      expect(provider.liveCourseOutlineCustomColorInitialized, isTrue);
      expect(
        provider.liveCourseOutlineColorValue,
        deriveLiveCourseOutlineColorFromSeed(
          Color(provider.themeSeedColorValue),
        ).toARGB32(),
      );
    });

    testWidgets('关闭课程描边后 provider 会保存设置', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('课程描边'), 200);
      await tester.tap(find.text('课程描边'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(SwitchListTile, '开启课程描边'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(provider.liveCourseOutlineEnabled, isFalse);
    });

    testWidgets('描边宽度显示会带单位', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('课程描边'), 200);
      expect(find.text('2.5 px'), findsOneWidget);

      await tester.tap(find.text('课程描边'));
      await tester.pumpAndSettle();

      expect(find.text('2.5 px'), findsWidgets);
    });

    testWidgets('五彩缤纷模式会显示 UI 配色和课程颜色列表', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: () {
            final themed = _buildTestAppData();
            return themed.copyWith(
              themeColorMode: themeColorModeColorful,
              colorfulUiColorValues: const {colorfulUiPrimaryKey: 0xFF112233},
              studentMode: themed.studentMode.copyWith(
                courseNameColorValues: const {'高等数学': 0xFF445566},
              ),
            );
          }(),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('单调主题色'), findsOneWidget);
      expect(find.text('五彩缤纷'), findsOneWidget);
      expect(find.text('UI 配色'), findsOneWidget);
      expect(find.text('课程颜色'), findsOneWidget);
      expect(find.text('主色'), findsOneWidget);
      expect(find.text('辅色'), findsOneWidget);
      expect(find.text('强调色'), findsOneWidget);
      expect(find.text('课程文字色'), findsOneWidget);
      expect(find.text('高等数学'), findsOneWidget);
      expect(find.text('自定义颜色'), findsNothing);
    });

    testWidgets('单调主题色模式会隐藏五彩缤纷列表并显示原主题色入口', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: () {
            final themed = _buildTestAppData();
            return themed.copyWith(
              themeColorMode: themeColorModeSingle,
              studentMode: themed.studentMode.copyWith(
                courseNameColorValues: const {'高等数学': 0xFF445566},
              ),
            );
          }(),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('自定义颜色'), findsOneWidget);
      expect(find.text('UI 配色'), findsNothing);
      expect(find.text('课程颜色'), findsNothing);
    });

    testWidgets('调整描边宽度后 provider 会保存设置', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('课程描边'), 200);
      await tester.tap(find.text('课程描边'));
      await tester.pumpAndSettle();

      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged?.call(4.0);
      await tester.pumpAndSettle();
      expect(find.text('4 px'), findsWidgets);
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(
        provider.liveCourseOutlineWidth,
        greaterThan(defaultLiveCourseOutlineWidth),
      );
    });

    testWidgets('切换描边目标后 provider 会保存模式', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('课程描边'), 200);
      await tester.tap(find.text('课程描边'));
      await tester.pumpAndSettle();

      expect(find.text('描边目标'), findsNWidgets(2));
      await tester.tap(find.text('当前页全部课程').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(provider.liveCourseOutlineMode, liveCourseOutlineModeAllDisplayed);
      expect(find.text('当前页全部课程'), findsOneWidget);
    });

    testWidgets('课程文字色支持自动配色与自定义颜色切换', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            themeColorMode: themeColorModeColorful,
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: const MaterialApp(
            locale: Locale('zh'),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: ThemeSettingsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final courseTextTile = find.widgetWithText(ListTile, '课程文字色');
      await tester.ensureVisible(courseTextTile);
      await tester.pumpAndSettle();
      await tester.tap(courseTextTile);
      await tester.pumpAndSettle();

      expect(find.text('自动配色'), findsWidgets);
      expect(find.text('自定义颜色'), findsWidgets);
      await tester.tap(find.text('自定义颜色').last);
      await tester.pumpAndSettle();
      expect(find.byType(ColorPickerInput), findsOneWidget);

      final colorInput = tester.widget<ColorPickerInput>(
        find.byType(ColorPickerInput),
      );
      colorInput.onColorChanged(const Color(0xFF123456));
      await tester.pumpAndSettle();
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(
        provider.colorfulCourseTextColorMode,
        colorfulCourseTextColorModeCustom,
      );
      expect(
        provider.colorfulUiColorValues[colorfulCourseTextColorKey],
        0xFF123456,
      );

      await tester.tap(find.text('课程文字色'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('自动配色'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('应用设置'));
      await tester.pumpAndSettle();

      expect(
        provider.colorfulCourseTextColorMode,
        colorfulCourseTextColorModeAuto,
      );
      expect(
        provider.colorfulUiColorValues[colorfulCourseTextColorKey],
        0xFF123456,
      );
    });
  });

  group('主页与编辑器', () {
    testWidgets('未加载时先显示加载态', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );

      await tester.pumpWidget(MyApp(provider: provider));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('首次未同意隐私政策时显示弹窗而不是整页', (tester) async {
      final initialData = _buildTestAppData().copyWith(
        privacyPolicyAcceptedVersion: null,
        privacyPolicyAcceptedAtIso: null,
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: initialData),
      );
      await provider.load();
      provider.injectRemotePrivacyPolicyVersion('2026-04-20');

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('使用前请先同意隐私政策'), findsOneWidget);
      expect(find.text('测试课表A'), findsOneWidget);
      expect(find.text('查看完整隐私政策'), findsOneWidget);
      expect(find.text('同意并继续'), findsOneWidget);

      await tester.tap(find.text('同意并继续'));
      await tester.pumpAndSettle();

      expect(provider.hasAcceptedCurrentPrivacyPolicy, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('第 ${provider.selectedWeek} 周'), findsOneWidget);
    });

    testWidgets('主页显示精简标题、右上角添加课程且无 FAB', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('第 ${provider.selectedWeek} 周'), findsOneWidget);
      expect(find.text(provider.activeTimetable.config.name), findsOneWidget);
      expect(find.byTooltip('添加课程'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SingleChildScrollView &&
              widget.scrollDirection == Axis.horizontal,
        ),
        findsNothing,
      );
    });

    testWidgets('新建课程时显示周次入口且节次由时间自动推导', (tester) async {
      await tester.pumpWidget(
        _buildLocalizedApp(
          CourseEditorSheet(
            periodTimes: buildDefaultPeriodTimes().take(4).toList(),
            totalWeeks: 18,
            dayOfWeek: 2,
          ),
        ),
      );

      expect(find.text('周次'), findsOneWidget);
      expect(find.text('第 1-18 周'), findsOneWidget);
      expect(find.text('关联节次'), findsOneWidget);
      expect(find.text('第 1-2 节'), findsOneWidget);
    });

    testWidgets('课程详情优先展示地点和时间卡片', (tester) async {
      final appData = _buildTestAppData();
      final course = appData.studentMode.timetables.first.courses.first;
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: appData),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: _buildLocalizedApp(
            CourseDetailsSheet(
              courseId: course.id,
              weekday: course.dayOfWeek,
              conflictKey: null,
              isFullConflict: false,
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('地点'), findsOneWidget);
      expect(find.text('时间'), findsOneWidget);
      expect(find.text(course.location), findsOneWidget);
      expect(find.textContaining(course.timeRange), findsOneWidget);
    });

    testWidgets('手动检测更新时的更新弹窗包含官网 Google Play GitHub 和网盘按钮', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();
      final context = await _pumpUpdateHarness(tester, provider: provider);

      final future = AppUpdateCoordinator.checkForUpdates(
        context,
        provider: provider,
        source: UpdateCheckSource.manual,
        updateService: const FakeSuccessUpdateService(
          UpdateCheckResult(
            localVersion: '1.0.0',
            remoteVersion: '1.1.0',
            releaseUrl:
                'https://github.com/Mashiro0619/KeSchedule/releases/latest',
            officialWebsiteUrl: 'https://mashiro.tech/KeSchedule',
            updateContent: '更新说明',
            hasUpdate: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('官网'), findsOneWidget);
      expect(find.text('Google Play'), findsOneWidget);
      expect(find.text('GitHub 仓库'), findsOneWidget);
      expect(find.text('网盘'), findsOneWidget);
      expect(find.text('忽略此版本'), findsNothing);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      await future;
    });

    testWidgets('检测更新失败时会显示错误弹窗并提供官网 Google Play GitHub 和网盘按钮', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();
      final context = await _pumpUpdateHarness(tester, provider: provider);

      final future = AppUpdateCoordinator.checkForUpdates(
        context,
        provider: provider,
        source: UpdateCheckSource.manual,
        updateService: FakeThrowingUpdateService(Exception('boom')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('检测更新失败'), findsOneWidget);
      expect(find.text('官网'), findsOneWidget);
      expect(find.text('Google Play'), findsOneWidget);
      expect(find.text('GitHub 仓库'), findsOneWidget);
      expect(find.text('网盘'), findsOneWidget);
      expect(find.text('忽略此版本'), findsNothing);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      await future;
    });

    testWidgets('启动时检测更新失败的错误弹窗包含忽略此版本', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(initialData: _buildTestAppData()),
      );
      await provider.load();
      final context = await _pumpUpdateHarness(tester, provider: provider);

      final future = AppUpdateCoordinator.checkForUpdates(
        context,
        provider: provider,
        source: UpdateCheckSource.startup,
        updateService: FakeThrowingUpdateService(Exception('boom')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('检测更新失败'), findsOneWidget);
      expect(find.text('忽略此版本'), findsOneWidget);
      expect(find.text('官网'), findsOneWidget);
      expect(find.text('Google Play'), findsOneWidget);
      expect(find.text('GitHub 仓库'), findsOneWidget);
      expect(find.text('网盘'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      await future;
    });

    testWidgets('通用模式主页支持搜索过滤事件', (tester) async {
      final calendar = GeneralSchedule(
        id: 'cal1',
        name: 'Work',
        colorValue: 0xFFABCDEF,
        events: [
          GeneralEvent(
            id: 'evt1',
            calendarId: 'cal1',
            title: 'Dentist',
            startDateTimeIso: '2026-05-18T09:00:00.000',
            endDateTimeIso: '2026-05-18T10:00:00.000',
            colorValue: 0xFF123456,
          ),
          GeneralEvent(
            id: 'evt2',
            calendarId: 'cal1',
            title: 'Review',
            startDateTimeIso: '2026-05-18T11:00:00.000',
            endDateTimeIso: '2026-05-18T12:00:00.000',
          ),
        ],
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            activeMode: AppMode.general,
            generalMode: GeneralScheduleData(
              activeScheduleId: calendar.id,
              schedules: [calendar],
              selectedDateIso: '2026-05-18',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: _buildLocalizedApp(
            const GeneralScheduleHomeScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dentist'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'dentist');
      await tester.pumpAndSettle();

      expect(find.text('Dentist'), findsOneWidget);
      expect(find.text('Review'), findsNothing);

      await tester.tap(find.byTooltip('Filter by color'));
      await tester.pumpAndSettle();

      expect(find.text('#FF123456'), findsOneWidget);
      expect(find.text('#FFABCDEF'), findsNothing);
    });

    testWidgets('general reminder strip can mark an occurrence handled', (
      tester,
    ) async {
      // Pin a wider/taller surface so the day-view event card has room for the
      // title in a single line regardless of where DateTime.now() places it in
      // the day grid. Without this the card can be only ~84px wide, wrapping
      // the title to two lines and overflowing the fixed-height row by ~6px.
      await tester.binding.setSurfaceSize(const Size(1200, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final now = DateTime.now();
      final start = now.add(const Duration(minutes: 5));
      final end = start.add(const Duration(hours: 1));
      final calendar = GeneralSchedule(
        id: 'cal1',
        name: 'Work',
        events: [
          GeneralEvent(
            id: 'evt_reminder',
            calendarId: 'cal1',
            title: 'Reminder Event',
            startDateTimeIso: start.toIso8601String(),
            endDateTimeIso: end.toIso8601String(),
            reminders: const [GeneralEventReminder(minutesBefore: 10)],
          ),
        ],
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            activeMode: AppMode.general,
            generalMode: GeneralScheduleData(
              activeScheduleId: calendar.id,
              schedules: [calendar],
              selectedDateIso: start.toIso8601String().split('T').first,
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: _buildLocalizedApp(
            const GeneralScheduleHomeScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Upcoming'), findsOneWidget);

      await tester.tap(find.byTooltip('Mark handled'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Upcoming'), findsNothing);
      expect(provider.generalReminderItems(now: now), isEmpty);
    });

    testWidgets('general list view exposes quick date jump controls', (
      tester,
    ) async {
      final calendar = GeneralSchedule(
        id: 'cal1',
        name: 'Work',
        events: [
          GeneralEvent(
            id: 'evt1',
            calendarId: 'cal1',
            title: 'List Event',
            startDateTimeIso: '2026-05-18T09:00:00.000',
            endDateTimeIso: '2026-05-18T10:00:00.000',
          ),
        ],
      );
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            activeMode: AppMode.general,
            generalMode: GeneralScheduleData(
              activeScheduleId: calendar.id,
              schedules: [calendar],
              selectedDateIso: '2026-05-18',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: _buildLocalizedApp(
            const GeneralScheduleHomeScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('List'));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Pick date'), findsOneWidget);
    });

    testWidgets('general week view fits all visible days on narrow screens', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      const calendar = GeneralSchedule(id: 'cal1', name: 'Work', events: []);
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            activeMode: AppMode.general,
            generalMode: GeneralScheduleData(
              activeScheduleId: 'cal1',
              schedules: [calendar],
              selectedDateIso: '2026-05-18',
            ),
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(
        ChangeNotifierProvider<TimetableProvider>.value(
          value: provider,
          child: _buildLocalizedApp(
            const GeneralScheduleHomeScreen(),
            locale: const Locale('en'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (final label in const [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      final sundayRight = tester.getBottomRight(find.text('Sun')).dx;
      expect(sundayRight, lessThanOrEqualTo(390));

      final horizontalScrollViews = tester
          .widgetList<SingleChildScrollView>(find.byType(SingleChildScrollView))
          .where((widget) => widget.scrollDirection == Axis.horizontal);
      expect(horizontalScrollViews, isEmpty);
    });

    testWidgets('没有课表时显示新建和导入引导', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: AppData(
            activeMode: AppMode.student,
            studentMode: StudentModeData(
              activeTimetableId: '',
              timetables: const [],
              periodTimeSets: [
                PeriodTimeSet(
                  id: 'set1',
                  name: '默认节次',
                  periodTimes: [
                    CoursePeriodTime(
                      index: 1,
                      startMinutes: 480,
                      endMinutes: 525,
                    ),
                  ],
                ),
              ],
            ),
            generalMode: GeneralScheduleData.fromJson(const {}),
            privacyPolicyAcceptedVersion: '2026-04-20',
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(MyApp(provider: provider));
      await tester.pumpAndSettle();

      expect(find.text('No timetable yet'), findsOneWidget);
      expect(find.text('New timetable'), findsOneWidget);
      expect(find.text('Import timetable'), findsOneWidget);
    });

    testWidgets('完全冲突时默认显示更长课程并显示冲突标记', (tester) async {
      final periodTimes = buildDefaultPeriodTimes().take(4).toList();
      final timetable = TimetableData(
        id: 'table1',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'long',
            name: '长课',
            teacher: '',
            location: 'A101',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1, 2],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[1].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[1].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
          CourseItem(
            id: 'short',
            name: '短课',
            teacher: '',
            location: 'B202',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 900,
              height: 700,
              child: TimetableGrid(
                timetable: timetable,
                periodTimes: periodTimes,
                weekDateStart: DateTime(2026, 2, 23),
                selectedWeek: 1,
                realCurrentWeek: 1,
                localeCode: 'zh',
                preserveGaps: true,
                showPastEndedCourses: false,
                showFutureCourses: true,
                showGridLines: true,
                themeColorMode: themeColorModeSingle,
                courseNameColorValues: const {},
                colorfulCourseTextColorMode: colorfulCourseTextColorModeAuto,
                liveCourseOutlineEnabled: true,
                liveCourseOutlineMode: liveCourseOutlineModeCurrentOrNext,
                onCourseTap: (_) {},
                onEmptySlotTap: (_) {},
                liveCourseOutlineColorValue: defaultLiveCourseOutlineColorValue,
                liveCourseOutlineWidth: defaultLiveCourseOutlineWidth,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('长课'), findsOneWidget);
      expect(find.text('短课'), findsNothing);
      expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
    });

    testWidgets('完全冲突时会读取已保存的外部显示课程偏好', (tester) async {
      final periodTimes = buildDefaultPeriodTimes().take(4).toList();
      final timetable = TimetableData(
        id: 'table1',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'a_long',
            name: '长课',
            teacher: '',
            location: 'A101',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1, 2],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[1].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[1].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
          CourseItem(
            id: 'b_short',
            name: '短课',
            teacher: '',
            location: 'B202',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 900,
              height: 700,
              child: TimetableGrid(
                timetable: timetable,
                periodTimes: periodTimes,
                weekDateStart: DateTime(2026, 2, 23),
                selectedWeek: 1,
                realCurrentWeek: 1,
                localeCode: 'zh',
                preserveGaps: true,
                showPastEndedCourses: false,
                showFutureCourses: true,
                showGridLines: true,
                themeColorMode: themeColorModeSingle,
                courseNameColorValues: const {},
                colorfulCourseTextColorMode: colorfulCourseTextColorModeAuto,
                displayedCourseIdForConflict: (_) => 'b_short',
                liveCourseOutlineEnabled: true,
                liveCourseOutlineMode: liveCourseOutlineModeCurrentOrNext,
                onCourseTap: (_) {},
                onEmptySlotTap: (_) {},
                liveCourseOutlineColorValue: defaultLiveCourseOutlineColorValue,
                liveCourseOutlineWidth: defaultLiveCourseOutlineWidth,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('短课'), findsOneWidget);
      expect(find.text('长课'), findsNothing);
    });

    testWidgets('TimetableGrid 在单调和五彩缤纷模式下都会渲染课程卡片', (tester) async {
      final periodTimes = buildDefaultPeriodTimes().take(4).toList();
      final timetable = TimetableData(
        id: 'table_colorful',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'course_colorful',
            name: '色彩课程',
            teacher: '教师',
            location: 'A101',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1, 2],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[1].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[1].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      Future<void> pumpGrid({
        required String themeColorMode,
        required Map<String, int> courseNameColorValues,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 900,
                height: 700,
                child: TimetableGrid(
                  timetable: timetable,
                  periodTimes: periodTimes,
                  weekDateStart: DateTime(2026, 2, 23),
                  selectedWeek: 1,
                  realCurrentWeek: 1,
                  localeCode: 'zh',
                  preserveGaps: true,
                  showPastEndedCourses: false,
                  showFutureCourses: true,
                  showGridLines: true,
                  themeColorMode: themeColorMode,
                  courseNameColorValues: courseNameColorValues,
                  colorfulCourseTextColorMode: colorfulCourseTextColorModeAuto,
                  liveCourseOutlineEnabled: true,
                  liveCourseOutlineMode: liveCourseOutlineModeCurrentOrNext,
                  onCourseTap: (_) {},
                  onEmptySlotTap: (_) {},
                  liveCourseOutlineColorValue:
                      defaultLiveCourseOutlineColorValue,
                  liveCourseOutlineWidth: defaultLiveCourseOutlineWidth,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await pumpGrid(
        themeColorMode: themeColorModeSingle,
        courseNameColorValues: const {},
      );
      expect(find.text('色彩课程'), findsOneWidget);

      await pumpGrid(
        themeColorMode: themeColorModeColorful,
        courseNameColorValues: const {'色彩课程': 0xFFAA3344},
      );
      expect(find.text('色彩课程'), findsOneWidget);
    });

    testWidgets('TimetableGrid 会在全部描边时继续突出当前或下一节课程', (tester) async {
      final periodTimes = buildDefaultPeriodTimes().take(4).toList();
      final timetable = TimetableData(
        id: 'table_outline_mode',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'course_a',
            name: '课程A',
            teacher: '',
            location: '',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
          CourseItem(
            id: 'course_b',
            name: '课程B',
            teacher: '',
            location: '',
            dayOfWeek: 2,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      Future<List<BorderSide>> pumpGrid(
        String mode, {
        required TimetableLiveCourseTarget liveCourseTarget,
      }) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 900,
                height: 700,
                child: TimetableGrid(
                  timetable: timetable,
                  periodTimes: periodTimes,
                  weekDateStart: DateTime(2026, 2, 23),
                  selectedWeek: 1,
                  realCurrentWeek: 1,
                  localeCode: 'zh',
                  preserveGaps: true,
                  showPastEndedCourses: false,
                  showFutureCourses: true,
                  showGridLines: true,
                  themeColorMode: themeColorModeSingle,
                  courseNameColorValues: const {},
                  colorfulCourseTextColorMode: colorfulCourseTextColorModeAuto,
                  liveCourseTarget: liveCourseTarget,
                  liveCourseOutlineEnabled: true,
                  liveCourseOutlineMode: mode,
                  onCourseTap: (_) {},
                  onEmptySlotTap: (_) {},
                  liveCourseOutlineColorValue:
                      defaultLiveCourseOutlineColorValue,
                  liveCourseOutlineWidth: defaultLiveCourseOutlineWidth,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        return find
            .byType(Card)
            .evaluate()
            .map(
              (element) =>
                  (tester.widget<Card>(find.byWidget(element.widget)).shape
                          as RoundedRectangleBorder)
                      .side,
            )
            .where((side) => side.width >= 0)
            .toList();
      }

      final currentOrNextSides = await pumpGrid(
        liveCourseOutlineModeCurrentOrNext,
        liveCourseTarget: const TimetableLiveCourseTarget(
          week: 1,
          weekday: 1,
          courseId: 'course_a',
          isCurrentCourse: true,
        ),
      );
      final currentOrNextHighlighted = currentOrNextSides
          .where((side) => side != BorderSide.none)
          .toList();
      expect(currentOrNextHighlighted.length, 1);
      final currentOrNextWidth = currentOrNextHighlighted.single.width;
      expect(find.byIcon(Icons.notifications_active_outlined), findsNothing);

      final nextCourseSides = await pumpGrid(
        liveCourseOutlineModeCurrentOrNext,
        liveCourseTarget: const TimetableLiveCourseTarget(
          week: 1,
          weekday: 2,
          courseId: 'course_b',
          isCurrentCourse: false,
        ),
      );
      final nextCourseHighlighted = nextCourseSides
          .where((side) => side != BorderSide.none)
          .toList();
      expect(nextCourseHighlighted.length, 1);
      expect(nextCourseHighlighted.single.width, currentOrNextWidth);
      expect(find.byIcon(Icons.notifications_active_outlined), findsNothing);

      final allDisplayedSides = await pumpGrid(
        liveCourseOutlineModeAllDisplayed,
        liveCourseTarget: const TimetableLiveCourseTarget(
          week: 1,
          weekday: 1,
          courseId: 'course_a',
          isCurrentCourse: true,
        ),
      );
      final highlightedSides = allDisplayedSides
          .where((side) => side != BorderSide.none)
          .toList();
      expect(highlightedSides.length, 2);
      final widths = highlightedSides.map((side) => side.width).toList()
        ..sort();
      expect(widths.last, greaterThan(widths.first));
      expect(widths.last, greaterThan(currentOrNextWidth));
      expect(find.byIcon(Icons.notifications_active_outlined), findsNothing);
    });

    testWidgets('五彩缤纷模式会为所有课程块使用统一自动文字颜色', (tester) async {
      final periodTimes = buildDefaultPeriodTimes().take(4).toList();
      final timetable = TimetableData(
        id: 'table_text_color',
        config: TimetableConfig(
          name: '测试课表',
          startDate: DateTime(2026, 2, 23),
          totalWeeks: 18,
          periodTimeSetId: 'set1',
        ),
        courses: [
          CourseItem(
            id: 'dark_course',
            name: '深色课',
            teacher: '',
            location: '',
            dayOfWeek: 1,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
          CourseItem(
            id: 'light_course',
            name: '浅色课',
            teacher: '',
            location: '',
            dayOfWeek: 2,
            semesterWeeks: const [1],
            periods: const [1],
            startMinutes: periodTimes[0].startMinutes,
            endMinutes: periodTimes[0].endMinutes,
            timeRange: buildTimeRange(
              periodTimes[0].startMinutes,
              periodTimes[0].endMinutes,
            ),
            credit: 0,
            remarks: '',
            customFields: const {},
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 900,
              height: 700,
              child: TimetableGrid(
                timetable: timetable,
                periodTimes: periodTimes,
                weekDateStart: DateTime(2026, 2, 23),
                selectedWeek: 1,
                realCurrentWeek: 1,
                localeCode: 'zh',
                preserveGaps: true,
                showPastEndedCourses: false,
                showFutureCourses: true,
                showGridLines: true,
                themeColorMode: themeColorModeColorful,
                courseNameColorValues: const {
                  '深色课': 0xFF111111,
                  '浅色课': 0xFFFFFF99,
                },
                colorfulCourseTextColorMode: colorfulCourseTextColorModeAuto,
                liveCourseOutlineEnabled: true,
                liveCourseOutlineMode: liveCourseOutlineModeCurrentOrNext,
                onCourseTap: (_) {},
                onEmptySlotTap: (_) {},
                liveCourseOutlineColorValue: defaultLiveCourseOutlineColorValue,
                liveCourseOutlineWidth: defaultLiveCourseOutlineWidth,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final darkCourseText = tester.widget<Text>(find.text('深色课'));
      final lightCourseText = tester.widget<Text>(find.text('浅色课'));
      final darkColor = darkCourseText.style!.color!;
      final lightColor = lightCourseText.style!.color!;

      expect(darkColor, lightColor);
      final luminance = darkColor.computeLuminance();
      expect(luminance < 0.2 || luminance > 0.8, isTrue);
    });

    testWidgets('MyApp 在五彩缤纷模式下会覆盖 primary secondary tertiary', (tester) async {
      final provider = TimetableProvider(
        storage: MemoryTimetableStorage(
          initialData: _buildTestAppData().copyWith(
            themeColorMode: themeColorModeColorful,
            colorfulUiColorValues: const {
              colorfulUiPrimaryKey: 0xFF112233,
              colorfulUiSecondaryKey: 0xFF223344,
              colorfulUiTertiaryKey: 0xFF334455,
            },
            privacyPolicyAcceptedVersion: '2026-04-20',
          ),
        ),
      );
      await provider.load();

      await tester.pumpWidget(MyApp(provider: provider));
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final lightTheme = materialApp.theme!;
      final darkTheme = materialApp.darkTheme!;

      expect(lightTheme.colorScheme.primary, const Color(0xFF112233));
      expect(lightTheme.colorScheme.secondary, const Color(0xFF223344));
      expect(lightTheme.colorScheme.tertiary, const Color(0xFF334455));
      expect(darkTheme.colorScheme.primary, const Color(0xFF112233));
      expect(darkTheme.colorScheme.secondary, const Color(0xFF223344));
      expect(darkTheme.colorScheme.tertiary, const Color(0xFF334455));
    });
  });

  group('纯逻辑函数', () {
    // ── normalizeSemesterWeeks ──
    test('normalizeSemesterWeeks 空列表保持空', () {
      expect(normalizeSemesterWeeks([]), isEmpty);
    });

    test('normalizeSemesterWeeks 去重并排序', () {
      expect(normalizeSemesterWeeks([3, 1, 3, 2]), [1, 2, 3]);
    });

    test('normalizeSemesterWeeks 过滤非正数', () {
      expect(normalizeSemesterWeeks([-1, 0, 1, 2]), [1, 2]);
    });

    // ── matchesSemesterWeek ──
    test('matchesSemesterWeek 空周列表匹配任意周', () {
      final course = CourseItem(
        id: '1',
        name: '',
        teacher: '',
        location: '',
        dayOfWeek: 1,
        semesterWeeks: [],
        periods: [],
        startMinutes: 0,
        endMinutes: 0,
        timeRange: '',
        credit: 0,
        remarks: '',
        customFields: {},
      );
      expect(matchesSemesterWeek(course, 5), isTrue);
    });

    test('matchesSemesterWeek 精确匹配指定周', () {
      final course = CourseItem(
        id: '1',
        name: '',
        teacher: '',
        location: '',
        dayOfWeek: 1,
        semesterWeeks: [1, 3, 5],
        periods: [],
        startMinutes: 0,
        endMinutes: 0,
        timeRange: '',
        credit: 0,
        remarks: '',
        customFields: {},
      );
      expect(matchesSemesterWeek(course, 3), isTrue);
      expect(matchesSemesterWeek(course, 2), isFalse);
    });

    // ── buildPeriodTimesForCount ──
    test('buildPeriodTimesForCount count=0 返回至少1个节次', () {
      final result = buildPeriodTimesForCount(0);
      expect(result.length, 1);
      expect(result[0].index, 1);
    });

    test('buildPeriodTimesForCount 从 source 复制并重新编号', () {
      final source = [
        const CoursePeriodTime(index: 5, startMinutes: 600, endMinutes: 645),
        const CoursePeriodTime(index: 7, startMinutes: 700, endMinutes: 745),
      ];
      final result = buildPeriodTimesForCount(2, source: source);
      expect(result.length, 2);
      expect(result[0].index, 1);
      expect(result[0].startMinutes, 600);
      expect(result[1].index, 2);
      expect(result[1].startMinutes, 700);
    });

    test('buildPeriodTimesForCount 超出默认模板长度时自动补齐', () {
      final result = buildPeriodTimesForCount(15);
      expect(result.length, 15);
      expect(result[0].index, 1);
      expect(result[14].index, 15);
      expect(result[14].startMinutes, greaterThan(result[13].endMinutes));
    });

    // ── buildOverlapGroups ──
    test('buildOverlapGroups 空列表返回空', () {
      expect(buildOverlapGroups([]), isEmpty);
    });

    test('buildOverlapGroups 不重叠课程各自成组', () {
      final courses = [
        CourseItem(
          id: '1',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 525,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
        CourseItem(
          id: '2',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 600,
          endMinutes: 645,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
      ];
      final groups = buildOverlapGroups(courses);
      expect(groups.length, 2);
      expect(groups[0].courses.length, 1);
      expect(groups[1].courses.length, 1);
      expect(groups[0].courses[0].id, '1');
      expect(groups[1].courses[0].id, '2');
    });

    test('buildOverlapGroups 时间重叠课程合并成一组', () {
      final courses = [
        CourseItem(
          id: '1',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 570,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
        CourseItem(
          id: '2',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 540,
          endMinutes: 630,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
      ];
      final groups = buildOverlapGroups(courses);
      expect(groups.length, 1);
      expect(groups[0].courses.length, 2);
    });

    // ── isFullConflictGroup ──
    test('isFullConflictGroup 单个课程不是完全冲突', () {
      final courses = [
        CourseItem(
          id: '1',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 570,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
      ];
      expect(isFullConflictGroup(courses), isFalse);
    });

    test('isFullConflictGroup 完全相同时间范围的课程是完全冲突', () {
      final courses = [
        CourseItem(
          id: '1',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 570,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
        CourseItem(
          id: '2',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 570,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
      ];
      expect(isFullConflictGroup(courses), isTrue);
    });

    test('isFullConflictGroup 一个包含另一个时也是完全冲突', () {
      final courses = [
        CourseItem(
          id: '1',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 480,
          endMinutes: 600,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
        CourseItem(
          id: '2',
          name: '',
          teacher: '',
          location: '',
          dayOfWeek: 1,
          semesterWeeks: [],
          periods: [],
          startMinutes: 500,
          endMinutes: 550,
          timeRange: '',
          credit: 0,
          remarks: '',
          customFields: {},
        ),
      ];
      expect(isFullConflictGroup(courses), isTrue);
    });

    // ── AppData.fromJson edge cases ──
    test('AppData.fromJson 空 Map 仍返回有效 AppData', () {
      final data = AppData.fromJson({});
      expect(data.studentMode.timetables, isEmpty);
      expect(data.studentMode.periodTimeSets, isEmpty);
      expect(data.studentMode.activeTimetableId, '');
    });

    test('AppData.fromJson 缺失字段不崩溃', () {
      final data = AppData.fromJson({
        'timetables': [
          {
            'id': 't1',
            'config': {'name': 'Test', 'totalWeeks': 20},
            'courses': [],
          },
        ],
      });
      expect(data.studentMode.timetables, hasLength(1));
      expect(data.studentMode.timetables.first.config.name, 'Test');
    });

    test('AppData.fromJson 忽略无效的 activeTimetableId', () {
      final data = AppData.fromJson({
        'activeTimetableId': 'nonexistent',
        'timetables': [
          {
            'id': 't1',
            'config': {'name': 'T1', 'totalWeeks': 10},
            'courses': [],
          },
        ],
      });
      expect(data.studentMode.activeTimetableId, 't1');
    });

    // ── ImportExportEnvelope roundtrip ──
    test('ImportExportEnvelope encode/decode roundtrip', () {
      final original = ImportExportEnvelope(
        schema: appDataSchema,
        version: importExportVersion,
        data: {'key': 'value', 'num': 42},
      );
      final encoded = original.encode();
      final decoded = ImportExportEnvelope.decode(encoded);
      expect(decoded.schema, appDataSchema);
      expect(decoded.version, importExportVersion);
      expect(decoded.data['key'], 'value');
      expect(decoded.data['num'], 42);
    });

    test('ImportExportEnvelope accepts legacy KeSchedule schemas', () {
      final source = ImportExportEnvelope(
        schema: 'KeSchedule-period-times',
        version: importExportVersion,
        data: {
          'periodTimes': [
            {'index': 7, 'startMinutes': 600, 'endMinutes': 645},
          ],
        },
      ).encode();

      final decoded = decodePeriodTimesEnvelope(source);

      expect(decoded, hasLength(1));
      expect(decoded.single.index, 7);
      expect(decoded.single.startMinutes, 600);
    });

    test(
      'bundled default period times asset uses a supported schema',
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        final source = await rootBundle.loadString(defaultPeriodTimesAssetPath);

        final decoded = decodePeriodTimesEnvelope(source);

        expect(decoded, hasLength(13));
        expect(decoded.first.startMinutes, 480);
        expect(decoded.last.endMinutes, 1250);
      },
    );

    test('ImportExportEnvelope schema 错误时会抛异常', () {
      final envelope = ImportExportEnvelope(
        schema: 'wrong',
        version: importExportVersion,
        data: const {},
      );
      final source = envelope.encode();
      // decodePeriodTimesEnvelope 内部调用 _ensureSupportedEnvelope
      expect(
        () => decodePeriodTimesEnvelope(source),
        throwsA(isA<FormatException>()),
      );
    });

    test('ImportExportEnvelope 版本过高会抛异常', () {
      final envelope = ImportExportEnvelope(
        schema: periodTimesSchema,
        version: 999,
        data: {'periodTimes': []},
      );
      final source = envelope.encode();
      expect(
        () => decodePeriodTimesEnvelope(source),
        throwsA(isA<FormatException>()),
      );
    });

    test('TimetableEntry course adapter 保留标题地点开始结束时间', () {
      final periods = buildDefaultPeriodTimes();
      final course = CourseItem(
        id: 'c1',
        name: '高等数学',
        teacher: '陈老师',
        location: 'A-201',
        dayOfWeek: 3,
        semesterWeeks: buildAllSemesterWeeks(18),
        periods: const [1, 2],
        startMinutes: periods[0].startMinutes,
        endMinutes: periods[1].endMinutes,
        timeRange: buildTimeRange(
          periods[0].startMinutes,
          periods[1].endMinutes,
        ),
        credit: 4,
        remarks: '',
        customFields: const {},
      );
      final entry = courseToEntry(course);
      expect(entry.id, 'c1');
      expect(entry.title, '高等数学');
      expect(entry.location, 'A-201');
      expect(entry.teacher, '陈老师');
      expect(entry.dayOfWeek, 3);
      expect(entry.startMinutes, periods[0].startMinutes);
      expect(entry.endMinutes, periods[1].endMinutes);
      expect(entry.kind, TimetableEntryKind.course);
      expect(entry.source, same(course));
    });

    test('TimetableEntry occurrence adapter 保留标题地点开始结束时间和持续时间', () {
      final event = GeneralEvent(
        id: 'evt1',
        calendarId: 'sched1',
        title: '会议',
        location: 'Room B',
        startDateTimeIso: '2026-05-20T14:00:00.000',
        endDateTimeIso: '2026-05-20T15:30:00.000',
        colorValue: 0xFF123456,
      );
      final schedule = GeneralSchedule(
        id: 'sched1',
        name: 'Work',
        events: [event],
      );
      final occurrence = GeneralEventOccurrence(
        event: event,
        calendar: schedule,
        start: DateTime(2026, 5, 20, 14, 0),
        end: DateTime(2026, 5, 20, 15, 30),
        sequence: 0,
      );
      final entry = occurrenceToEntry(occurrence);
      expect(entry.id, 'evt1');
      expect(entry.title, '会议');
      expect(entry.location, 'Room B');
      expect(entry.teacher, '');
      expect(entry.dayOfWeek, DateTime.wednesday);
      expect(entry.startMinutes, 840);
      expect(entry.endMinutes, 930);
      expect(entry.colorValue, 0xFF123456);
      expect(entry.kind, TimetableEntryKind.generalEvent);
      expect(entry.source, same(occurrence));
    });
  });
}
