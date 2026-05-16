import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManagerStorage {
  ///file manager storage singleton
  static final _instance = FileManagerStorage._();

  FileManagerStorage._();

  factory FileManagerStorage() {
    return _instance;
  }

  late final Directory _appDocument;
  late final File _tasksFile;

  Future<void> init() async {
    _appDocument = await getApplicationDocumentsDirectory();
    _tasksFile = File("${_appDocument.path}/my_tasks.json");
    print(_tasksFile.path);
  }

  void saveTask(List<dynamic> taskList) async {
    final taskJson = jsonEncode(taskList);
    print("taskList:$taskList");
    print("taskJson:$taskJson");
    await _tasksFile.writeAsString(taskJson);
  }

  Future<List<dynamic>> loadTask() async {
    if (!await _tasksFile.exists()) return [];

    final taskJson = await _tasksFile.readAsString();
    final taskList = jsonDecode(taskJson) as List<dynamic>;
    return taskList;
  }

  clearTask() async {
    if (!await _tasksFile.exists()) return [];
    await _tasksFile.delete();
  }
}
