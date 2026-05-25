import '../models/school_import_models.dart';
import '../models/timetable_models.dart';
import '../providers/timetable_provider.dart';

class TimetableJsonImportPreview {
  const TimetableJsonImportPreview({
    required this.candidates,
    required this.hasBundledPeriodTimeSets,
  });

  final List<TimetableData> candidates;
  final bool hasBundledPeriodTimeSets;
}

class TimetableJsonImportRequest {
  const TimetableJsonImportRequest({
    required this.source,
    required this.timetableIds,
    required this.mode,
    required this.importBundledPeriodTimeSets,
    this.targetPeriodTimeSetId,
  });

  final String source;
  final List<String> timetableIds;
  final TimetableImportMode mode;
  final bool importBundledPeriodTimeSets;
  final String? targetPeriodTimeSetId;
}

class TimetableJsonImportService {
  const TimetableJsonImportService();

  TimetableJsonImportPreview preview(
    TimetableProvider provider,
    String source,
  ) {
    final envelope = ImportExportEnvelope.decode(source);
    final candidates = provider.previewImportTimetables(source);
    return TimetableJsonImportPreview(
      candidates: candidates,
      hasBundledPeriodTimeSets: _hasBundledPeriodTimeSets(envelope),
    );
  }

  Future<int> apply(
    TimetableProvider provider,
    TimetableJsonImportRequest request,
  ) {
    return provider.importSelectedTimetablesJson(
      request.source,
      timetableIds: request.timetableIds,
      mode: request.mode,
      importBundledPeriodTimeSets: request.importBundledPeriodTimeSets,
      targetPeriodTimeSetId: request.targetPeriodTimeSetId,
    );
  }
}

bool _hasBundledPeriodTimeSets(ImportExportEnvelope envelope) {
  if (isImportExportSchema(envelope.schema, timetableDataSchema)) {
    return _hasPeriodTimeSetList(envelope.data['periodTimeSets']) ||
        _hasLegacyTimetablePeriodConfig(envelope.data) ||
        _hasLegacyTimetablePeriodConfig(envelope.data['timetable']);
  }
  if (isImportExportSchema(envelope.schema, appDataSchema)) {
    final studentMode = envelope.data['studentMode'];
    return _hasPeriodTimeSetList(envelope.data['periodTimeSets']) ||
        (studentMode is Map &&
            _hasPeriodTimeSetList(studentMode['periodTimeSets']));
  }
  return false;
}

bool _hasPeriodTimeSetList(Object? value) {
  return value is List<dynamic> && value.isNotEmpty;
}

bool _hasLegacyTimetablePeriodConfig(Object? value) {
  if (value is! Map) {
    return false;
  }
  final config = value['config'];
  if (config is! Map) {
    return false;
  }
  return _hasPeriodTimeSetList(config['periodTimes']) ||
      config['dailyPeriods'] is num;
}
