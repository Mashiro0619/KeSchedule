import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/school_site_models.dart';
import 'school_site_store.dart';

class SchoolSiteService {
  const SchoolSiteService({SchoolSiteStore? store})
    : _store = store ?? const SchoolSiteStore();

  static const schoolSitesAssetPath = 'assets/school_sites.json';

  final SchoolSiteStore _store;

  Future<List<SchoolSite>> loadSites() async {
    final candidates = await _store.loadCandidates();
    for (final candidate in candidates) {
      try {
        final sites = decodeSchoolSites(candidate.source);
        await _promoteCandidate(candidate);
        return sites;
      } on FormatException catch (error, stackTrace) {
        debugPrint(
          'Stored school sites are invalid, falling back to bundled asset: '
          '$error\n$stackTrace',
        );
      }
    }
    final source = await rootBundle.loadString(schoolSitesAssetPath);
    return decodeSchoolSites(source);
  }

  Future<void> _promoteCandidate(SchoolSiteStoreCandidate candidate) async {
    try {
      await candidate.promote();
    } catch (error, stackTrace) {
      debugPrint(
        'Stored school sites loaded but could not promote backup: '
        '$error\n$stackTrace',
      );
    }
  }

  Future<void> saveSites(List<SchoolSite> sites) async {
    await _store.save(encodeSchoolSites(sites));
  }

  Future<String> exportSites(List<SchoolSite> sites) async {
    return encodeSchoolSites(sites);
  }

  Future<List<SchoolSite>> importSites(String source) async {
    final sites = decodeSchoolSites(source);
    await saveSites(sites);
    return sites;
  }

  Future<String?> storagePath() => _store.filePath();
}
