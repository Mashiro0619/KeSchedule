import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sked/data/timetable_storage.dart';
import 'package:sked/l10n/app_locale.dart';
import 'package:sked/l10n/app_localizations.dart';
import 'package:sked/models/timetable_models.dart';
import 'package:sked/providers/timetable_provider.dart';
import 'package:sked/screens/school_html_import_page.dart';
import 'package:sked/screens/school_sites_page.dart';
import 'package:sked/services/privacy_service.dart';
import 'package:sked/services/school_site_service.dart';
import 'package:sked/services/school_site_store.dart';

class _MemorySchoolSiteStore extends SchoolSiteStore {
  _MemorySchoolSiteStore(this.source) : super.base();

  String? source;

  @override
  Future<String?> load() async => source;

  @override
  Future<void> save(String source) async {
    this.source = source;
  }

  @override
  Future<String?> filePath() async => 'memory://school-sites';
}

class _MemoryTimetableStorage implements TimetableStorage {
  _MemoryTimetableStorage(this.data);

  AppData? data;

  @override
  Future<StorageLoadResult> load() async =>
      StorageLoadResult(data: data, recoveryStatus: RecoveryStatus.none);

  @override
  Future<void> save(AppData data) async {
    this.data = data;
  }

  @override
  Future<String?> filePath() async => 'memory://school-sites-test';
}

class _NoopPrivacyService extends PrivacyService {
  const _NoopPrivacyService();

  @override
  Future<String?> fetchCurrentPrivacyPolicyVersion() async => null;
}

Future<TimetableProvider> _createProvider() async {
  final provider = TimetableProvider(
    storage: _MemoryTimetableStorage(
      buildInitialAppData(
        buildDefaultPeriodTimes(),
        localeCode: defaultLocaleCode,
      ).copyWith(activeMode: AppMode.student),
    ),
    systemLocaleCodeResolver: () => defaultLocaleCode,
    privacyService: const _NoopPrivacyService(),
  );
  await provider.load();
  return provider;
}

Future<void> _pumpSchoolSitesPage(
  WidgetTester tester,
  TimetableProvider provider,
) async {
  final siteService = SchoolSiteService(store: _MemorySchoolSiteStore('[]'));
  await tester.pumpWidget(
    ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SchoolSitesPage(siteService: siteService),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add school entry ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    await _pumpSchoolSitesPage(tester, provider);

    final addButton = find.byTooltip('Add school');
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.tap(addButton, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Add school'), findsWidgets);
  });

  testWidgets('HTML import entry ignores rapid duplicate taps', (tester) async {
    final provider = await _createProvider();
    await _pumpSchoolSitesPage(tester, provider);

    final htmlImportButton = find.byTooltip(
      'Import by pasting timetable page content',
    );
    expect(htmlImportButton, findsOneWidget);

    await tester.tap(htmlImportButton);
    await tester.tap(htmlImportButton, warnIfMissed: false);
    await _pumpRouteTransition(tester);

    expect(
      find.byType(SchoolHtmlImportPage, skipOffstage: false),
      findsOneWidget,
    );
  });
}
