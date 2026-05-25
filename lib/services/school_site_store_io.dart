import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'school_site_store.dart';

class PlatformSchoolSiteStore extends SchoolSiteStore {
  const PlatformSchoolSiteStore({
    Future<Directory> Function()? directoryProvider,
  }) : _directoryProvider = directoryProvider,
       super.base();

  static const _fileName = 'Sked_school_sites.json';
  static const _backupSuffix = '.bak';
  static const _tempSuffix = '.tmp';

  final Future<Directory> Function()? _directoryProvider;

  @override
  Future<String?> load() async {
    final candidates = await loadCandidates();
    if (candidates.isEmpty) {
      return null;
    }
    final first = candidates.first;
    try {
      await first.promote();
    } catch (_) {
      // Loading should still succeed even if best-effort promotion fails.
    }
    return first.source;
  }

  @override
  Future<List<SchoolSiteStoreCandidate>> loadCandidates() async {
    final file = await _resolveFile();
    final backup = File('${file.path}$_backupSuffix');
    final result = <SchoolSiteStoreCandidate>[];

    final mainContent = await _readNonEmpty(file);
    if (mainContent != null) {
      result.add(SchoolSiteStoreCandidate(source: mainContent));
    }

    final backupContent = await _readNonEmpty(backup);
    if (backupContent != null) {
      result.add(
        SchoolSiteStoreCandidate(
          source: backupContent,
          promote: () => _restoreBackupToMain(backup: backup, main: file),
        ),
      );
    }

    return result;
  }

  @override
  Future<void> save(String source) async {
    final file = await _resolveFile();
    final tmp = File('${file.path}$_tempSuffix');
    final backup = File('${file.path}$_backupSuffix');

    final raf = await tmp.open(mode: FileMode.write);
    try {
      await raf.writeString(source);
      await raf.flush();
    } finally {
      await raf.close();
    }

    if (await file.exists()) {
      if (await backup.exists()) {
        await backup.delete();
      }
      await file.rename(backup.path);
    }
    await tmp.rename(file.path);
  }

  @override
  Future<String?> filePath() async {
    final file = await _resolveFile();
    return file.path;
  }

  Future<File> _resolveFile() async {
    final directoryProvider =
        _directoryProvider ?? getApplicationDocumentsDirectory;
    final directory = await directoryProvider();
    return File(path.join(directory.path, _fileName));
  }

  Future<String?> _readNonEmpty(File file) async {
    try {
      if (!await file.exists()) {
        return null;
      }
      final content = await file.readAsString();
      return content.trim().isEmpty ? null : content;
    } catch (_) {
      return null;
    }
  }

  Future<void> _restoreBackupToMain({
    required File backup,
    required File main,
  }) async {
    final tmp = File('${main.path}$_tempSuffix');
    if (await tmp.exists()) {
      await tmp.delete();
    }
    await backup.copy(tmp.path);
    if (await main.exists()) {
      await main.delete();
    }
    await tmp.rename(main.path);
  }
}
