import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:tasky_app/core/constant/constant.dart';
import 'package:tasky_app/model/task_model.dart';

class HiveManagerStorage {
  ///file manager storage singleton
  static final _instance = HiveManagerStorage._();

  HiveManagerStorage._();

  factory HiveManagerStorage() {
    return _instance;
  }

  // late final Directory _appDocument;
  // late final File _tasksFile;
  late Box<TaskModel> _taskBox;
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    _taskBox = await Hive.openBox<TaskModel>(Constant.taskNameCollection);

    // _appDocument = await getApplicationDocumentsDirectory();
    // _tasksFile = File("${_appDocument.path}/my_tasks.json");
    // print(_tasksFile.path);
  }

  Future<void> saveTask(List<TaskModel> taskList) async {
    await _taskBox.clear();
    await _taskBox.addAll(taskList);
    // final taskJson = jsonEncode(taskList);
    // print("taskList:$taskList");
    // print("taskJson:$taskJson");
    // await _tasksFile.writeAsString(taskJson);
  }

  List<TaskModel> loadTask() {
    return _taskBox.values.toList();
    // if (!await _tasksFile.exists()) return [];
    //
    // final taskJson = await _tasksFile.readAsString();
    // final taskList = jsonDecode(taskJson) as List<dynamic>;
    // return taskList;
  }

  Future<void> clearTask() async {
    await _taskBox.clear();
    // if (!await _tasksFile.exists()) return [];
    // await _tasksFile.delete();
  }
}
