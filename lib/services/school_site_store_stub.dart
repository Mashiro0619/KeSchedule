import 'package:shared_preferences/shared_preferences.dart';

import 'school_site_store.dart';

class PlatformSchoolSiteStore extends SchoolSiteStore {
  const PlatformSchoolSiteStore() : super.base();

  static const _storageKey = 'Sked_school_sites_json';

  @override
  Future<String?> load() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_storageKey);
  }

  @override
  Future<void> save(String source) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, source);
  }

  @override
  Future<String?> filePath() async => 'browser://local-storage/$_storageKey';
}
