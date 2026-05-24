import 'app_localizations.dart';
import 'app_locale.dart';

abstract class AppStrings {
  factory AppStrings.forLocaleCode(String localeCode) {
    return _GeneratedAppStrings(
      lookupAppLocalizations(appLocaleFromCode(localeCode)),
    );
  }

  String get defaultPeriodTimeSetName;
  String get periodTimeSetFallbackName;
  String get untitledTimetableName;
  String get newTimetableName;
  String get newPeriodTimeSetName;
  String get emptyTimetableName;
  String importedPeriodTimeSetName(String timetableName);
  String get importFileTypeMismatchMessage;
  String get importFileVersionUnsupportedMessage;
  String get noPeriodTimesInImportMessage;
  String get noPeriodTimeAvailableMessage;
  String get selectAtLeastOneTimetableMessage;
  String get noExportableTimetableMessage;
  String get replaceActiveRequiresSingleTimetableMessage;
  String get noActiveTimetableToReplaceMessage;
  String get selectAtLeastOneScheduleMessage;
  String get noExportableScheduleMessage;
  String get noSchedulesInImportMessage;
  String get replaceActiveRequiresSingleScheduleMessage;
  String get noActiveScheduleToReplaceMessage;
  String get dataRestoredFromBackupNotice;
  String get dataBackupRestoreFailedNotice;
  String periodTimeSetInUseMessage(int count);
  String formatDayOfWeekLabel(int dayOfWeek);
  String formatWeekdayShortLabel(int dayOfWeek);
  String formatMonthLabel(int month);
  String formatSemesterWeeksLabel(List<int> semesterWeeks, {int? totalWeeks});
}

class _GeneratedAppStrings implements AppStrings {
  const _GeneratedAppStrings(this._l10n);

  final AppLocalizations _l10n;

  @override
  String get defaultPeriodTimeSetName => _l10n.defaultPeriodTimeSetName;

  @override
  String get periodTimeSetFallbackName => _l10n.periodTimeSetFallbackName;

  @override
  String get untitledTimetableName => _l10n.untitledTimetableName;

  @override
  String get newTimetableName => _l10n.newTimetableName;

  @override
  String get newPeriodTimeSetName => _l10n.newPeriodTimeSetName;

  @override
  String get emptyTimetableName => _l10n.emptyTimetableName;

  @override
  String importedPeriodTimeSetName(String timetableName) {
    return _l10n.importedPeriodTimeSetName(timetableName);
  }

  @override
  String get importFileTypeMismatchMessage => _l10n.importFileTypeMismatchMessage;

  @override
  String get importFileVersionUnsupportedMessage =>
      _l10n.importFileVersionUnsupportedMessage;

  @override
  String get noPeriodTimesInImportMessage => _l10n.noPeriodTimesInImportMessage;

  @override
  String get noPeriodTimeAvailableMessage => _l10n.noPeriodTimeAvailable;

  @override
  String get selectAtLeastOneTimetableMessage =>
      _l10n.selectAtLeastOneTimetableMessage;

  @override
  String get noExportableTimetableMessage => _l10n.noExportableTimetableMessage;

  @override
  String get replaceActiveRequiresSingleTimetableMessage =>
      _l10n.replaceActiveRequiresSingleTimetableMessage;

  @override
  String get noActiveTimetableToReplaceMessage =>
      _l10n.noActiveTimetableToReplaceMessage;

  @override
  String get selectAtLeastOneScheduleMessage =>
      _l10n.selectAtLeastOneScheduleMessage;

  @override
  String get noExportableScheduleMessage =>
      _l10n.noExportableScheduleMessage;

  @override
  String get noSchedulesInImportMessage =>
      _l10n.noSchedulesInImportMessage;

  @override
  String get replaceActiveRequiresSingleScheduleMessage =>
      _l10n.replaceActiveRequiresSingleScheduleMessage;

  @override
  String get noActiveScheduleToReplaceMessage =>
      _l10n.noActiveScheduleToReplaceMessage;

  @override
  String get dataRestoredFromBackupNotice =>
      _l10n.dataRestoredFromBackupNotice;

  @override
  String get dataBackupRestoreFailedNotice =>
      _l10n.dataBackupRestoreFailedNotice;

  @override
  String periodTimeSetInUseMessage(int count) {
    return _l10n.periodTimeSetInUseMessage(count);
  }

  @override
  String formatDayOfWeekLabel(int dayOfWeek) {
    return switch (dayOfWeek) {
      1 => _l10n.weekdayMonday,
      2 => _l10n.weekdayTuesday,
      3 => _l10n.weekdayWednesday,
      4 => _l10n.weekdayThursday,
      5 => _l10n.weekdayFriday,
      6 => _l10n.weekdaySaturday,
      _ => _l10n.weekdaySunday,
    };
  }

  @override
  String formatWeekdayShortLabel(int dayOfWeek) {
    return switch (dayOfWeek) {
      1 => _l10n.weekdayShortMonday,
      2 => _l10n.weekdayShortTuesday,
      3 => _l10n.weekdayShortWednesday,
      4 => _l10n.weekdayShortThursday,
      5 => _l10n.weekdayShortFriday,
      6 => _l10n.weekdayShortSaturday,
      _ => _l10n.weekdayShortSunday,
    };
  }

  @override
  String formatMonthLabel(int month) {
    final normalizedMonth = month.clamp(1, 12);
    return switch (normalizedMonth) {
      1 => _l10n.monthJanuary,
      2 => _l10n.monthFebruary,
      3 => _l10n.monthMarch,
      4 => _l10n.monthApril,
      5 => _l10n.monthMay,
      6 => _l10n.monthJune,
      7 => _l10n.monthJuly,
      8 => _l10n.monthAugust,
      9 => _l10n.monthSeptember,
      10 => _l10n.monthOctober,
      11 => _l10n.monthNovember,
      _ => _l10n.monthDecember,
    };
  }

  @override
  String formatSemesterWeeksLabel(List<int> semesterWeeks, {int? totalWeeks}) {
    final ranges = <String>[];
    if (semesterWeeks.isEmpty) {
      if (totalWeeks == null) {
        return _l10n.semesterWeeksWholeTerm;
      }
      return _l10n.semesterWeeksRange('1', '$totalWeeks');
    }
    var start = semesterWeeks.first;
    var previous = semesterWeeks.first;
    for (final week in semesterWeeks.skip(1)) {
      if (week == previous + 1) {
        previous = week;
        continue;
      }
      ranges.add(start == previous ? '$start' : '$start-$previous');
      start = previous = week;
    }
    ranges.add(start == previous ? '$start' : '$start-$previous');
    return _l10n.semesterWeeksList(ranges.join(_semesterWeeksSeparator));
  }

  String get _semesterWeeksSeparator {
    return _l10n.localeName.startsWith('zh') ? '、' : ', ';
  }
}
