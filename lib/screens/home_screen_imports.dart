part of 'home_screen.dart';

extension _HomeScreenImports on _HomeScreenState {
  Future<void> _importTimetableData(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    await TimetableImportFlow.importTimetables(context, provider);
  }

  Future<void> _importTimetablesFromText(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    final l10n = AppLocalizations.of(context);
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
  }

  Future<void> _importTimetableFromWeb(
    BuildContext context,
    TimetableProvider provider,
  ) async {
    await TimetableImportFlow.openSchoolSitesPage(context, provider);
  }
}
