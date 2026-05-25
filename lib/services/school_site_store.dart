import 'school_site_store_stub.dart'
    if (dart.library.io) 'school_site_store_io.dart';

class SchoolSiteStoreCandidate {
  const SchoolSiteStoreCandidate({
    required this.source,
    Future<void> Function()? promote,
  }) : _promote = promote;

  final String source;
  final Future<void> Function()? _promote;

  Future<void> promote() async {
    final action = _promote;
    if (action != null) {
      await action();
    }
  }
}

abstract class SchoolSiteStore {
  const factory SchoolSiteStore() = PlatformSchoolSiteStore;

  const SchoolSiteStore.base();

  Future<String?> load();

  Future<List<SchoolSiteStoreCandidate>> loadCandidates() async {
    final source = await load();
    if (source == null || source.trim().isEmpty) {
      return const <SchoolSiteStoreCandidate>[];
    }
    return [SchoolSiteStoreCandidate(source: source)];
  }

  Future<void> save(String source);

  Future<String?> filePath();
}
