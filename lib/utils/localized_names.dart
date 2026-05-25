import '../l10n/app_locale.dart';
import '../l10n/app_strings.dart';

AppStrings _stringsForLocale(String localeCode) {
  return AppStrings.forLocaleCode(localeCode);
}

String defaultPeriodTimeSetName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).defaultPeriodTimeSetName;
}

String periodTimeSetFallbackName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).periodTimeSetFallbackName;
}

String untitledTimetableName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).untitledTimetableName;
}

String newTimetableName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).newTimetableName;
}

String newPeriodTimeSetName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).newPeriodTimeSetName;
}

String emptyTimetableName({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).emptyTimetableName;
}

String importedPeriodTimeSetName(
  String timetableName, {
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).importedPeriodTimeSetName(timetableName);
}

String importFileTypeMismatchMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).importFileTypeMismatchMessage;
}

String importFileVersionUnsupportedMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).importFileVersionUnsupportedMessage;
}

String noPeriodTimesInImportMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noPeriodTimesInImportMessage;
}

String noPeriodTimeAvailableMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noPeriodTimeAvailableMessage;
}

String noImportableTimetablesMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noImportableTimetablesMessage;
}

String selectAtLeastOneTimetableMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).selectAtLeastOneTimetableMessage;
}

String noExportableTimetableMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noExportableTimetableMessage;
}

String replaceActiveRequiresSingleTimetableMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(
    localeCode,
  ).replaceActiveRequiresSingleTimetableMessage;
}

String noActiveTimetableToReplaceMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).noActiveTimetableToReplaceMessage;
}

String periodTimeSetInUseMessage(
  int count, {
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).periodTimeSetInUseMessage(count);
}

String selectAtLeastOneScheduleMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).selectAtLeastOneScheduleMessage;
}

String noExportableScheduleMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noExportableScheduleMessage;
}

String noSchedulesInImportMessage({String localeCode = defaultLocaleCode}) {
  return _stringsForLocale(localeCode).noSchedulesInImportMessage;
}

String replaceActiveRequiresSingleScheduleMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(
    localeCode,
  ).replaceActiveRequiresSingleScheduleMessage;
}

String noActiveScheduleToReplaceMessage({
  String localeCode = defaultLocaleCode,
}) {
  return _stringsForLocale(localeCode).noActiveScheduleToReplaceMessage;
}
