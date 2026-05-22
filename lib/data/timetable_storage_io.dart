import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/timetable_models.dart';
import 'timetable_storage.dart';

TimetableStorage createTimetableStorage() => _IoTimetableStorage();

/// IO 平台继续落真实文件，用户自己备份或者排查数据时都更直观。
class _IoTimetableStorage implements TimetableStorage {
  static const _fileName = 'Sked_data.json';

  @override
  Future<AppData?> load() async {
    final file = await _resolveFile();
    if (!await file.exists()) {
      return null;
    }
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return null;
    }
    return AppData.decode(content);
  }

  @override
  Future<void> save(AppData data) async {
    final file = await _resolveFile();
    await file.writeAsString(data.encode());
  }

  @override
  Future<String> filePath() async {
    final file = await _resolveFile();
    return file.path;
  }

  Future<File> _resolveFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, _fileName);
    return File(filePath);
  }
}
