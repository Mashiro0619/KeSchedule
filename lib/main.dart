import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'l10n/app_locale.dart';
import 'l10n/app_localizations.dart';
import 'models/timetable_models.dart';
import 'providers/timetable_provider.dart';
import 'screens/app_home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  _registerLicenses();
  final provider = TimetableProvider();
  unawaited(provider.load());
  runApp(MyApp(provider: provider));
}

void _registerLicenses() {
  LicenseRegistry.addLicense(() async* {
    final notice = await rootBundle.loadString('NOTICE');
    yield LicenseEntryWithLineBreaks([
      'App icon assets',
    ], notice);
  });
}

ThemeMode _themeModeFromValue(String value) {
  switch (value) {
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
    case 'light':
    default:
      return ThemeMode.light;
  }
}




ThemeData _buildTheme({
  required Color seedColor,
  required Brightness brightness,
  required String themeColorMode,
  required Map<String, int> colorfulUiColorValues,
}) {
  final baseScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
  );
  final colorScheme = themeColorMode == themeColorModeColorful
      ? baseScheme.copyWith(
          primary: Color(
            colorfulUiColorValues[colorfulUiPrimaryKey] ??
                baseScheme.primary.toARGB32(),
          ),
          secondary: Color(
            colorfulUiColorValues[colorfulUiSecondaryKey] ??
                baseScheme.secondary.toARGB32(),
          ),
          tertiary: Color(
            colorfulUiColorValues[colorfulUiTertiaryKey] ??
                baseScheme.tertiary.toARGB32(),
          ),
        )
      : baseScheme;
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.provider});

  final TimetableProvider provider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimetableProvider>.value(
      value: provider,
      child: Consumer<TimetableProvider>(
        builder: (context, timetableProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) =>
                AppLocalizations.of(context).appTitle,
            locale: appLocaleFromCode(timetableProvider.localeCode),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            themeMode: _themeModeFromValue(timetableProvider.themeMode),
            theme: _buildTheme(
              seedColor: Color(timetableProvider.themeSeedColorValue),
              brightness: Brightness.light,
              themeColorMode: timetableProvider.themeColorMode,
              colorfulUiColorValues: timetableProvider.colorfulUiColorValues,
            ),
            darkTheme: _buildTheme(
              seedColor: Color(timetableProvider.themeSeedColorValue),
              brightness: Brightness.dark,
              themeColorMode: timetableProvider.themeColorMode,
              colorfulUiColorValues: timetableProvider.colorfulUiColorValues,
            ),
            home: const AppHomeScreen(),
          );
        },
      ),
    );
  }
}
