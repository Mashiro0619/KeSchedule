import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchoolSiteStore {
  const SchoolSiteStore();

  static const _storageKey = 'Sked_school_sites_json';
  static const _fileName = 'Sked_school_sites.json';

  Future<String?> load() async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(_storageKey);
    }
    final file = await _resolveFile();
    if (!await file.exists()) {
      return null;
    }
    final content = await file.readAsString();
    return content.trim().isEmpty ? null : content;
  }

  Future<void> save(String source) async {
    if (kIsWeb) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_storageKey, source);
      return;
    }
    final file = await _resolveFile();
    await file.writeAsString(source);
  }

  Future<String?> filePath() async {
    if (kIsWeb) {
      return 'browser://local-storage/$_storageKey';
    }
    final file = await _resolveFile();
    return file.path;
  }

  Future<File> _resolveFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(path.join(directory.path, _fileName));
  }
}
