part of 'home_screen.dart';

extension _HomeScreenImports on _HomeScreenState {
  Future<void> _importTimetableData(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    if (_fileImportInProgress || !mounted) {
      return;
    }
    _setFileImportInProgress(true);
    try {
      await TimetableImportFlow.importTimetables(context, provider);
    } finally {
      _setFileImportInProgress(false);
    }
  }

  Future<void> _importTimetablesFromText(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    if (_textImportPageOpen || !mounted) {
      return;
    }
    _setTextImportPageOpen(true);
    final l10n = AppLocalizations.of(context);
    try {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TextImportPage(
            title: l10n.importTimetableText,
            onSubmit: (context, content) {
              return TimetableImportFlow.importTimetablesFromSource(
                context,
                provider,
                content,
              );
            },
          ),
        ),
      );
    } finally {
      _setTextImportPageOpen(false);
    }
  }

  Future<void> _importTimetableFromWeb(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    if (_schoolWebImportPageOpen || !mounted) {
      return;
    }
    _setSchoolWebImportPageOpen(true);
    try {
      await TimetableImportFlow.openSchoolSitesPage(context, provider);
    } finally {
      _setSchoolWebImportPageOpen(false);
    }
  }
}
