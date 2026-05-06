import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/model/task_model.dart';

class TasksController with ChangeNotifier {
  bool isLoading = false;

  List<TaskModel> tasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> highPriorityTasks = [];

  init() {
    _loadTasks();
  }

  void _loadTasks() async {
    isLoading = true;

    final taskJson = PreferencesManager().getString(StorageKey.tasks);

    List<TaskModel> loadedTasks = [];
    if (taskJson != null) {
      final taskListAfterDecoded = jsonDecode(taskJson) as List<dynamic>;
      loadedTasks = taskListAfterDecoded
          .map((e) => TaskModel.fromJson(e))
          .toList();
    }

    tasks = loadedTasks;
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completeTasks = tasks.where((element) => element.isDone).toList();
    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();

    //calculatePercentage();
    isLoading = false;
    notifyListeners();
  }

  Future<void> onDelete(int? id) async {
    tasks.removeWhere((element) => element.id == id);
    todoTasks.removeWhere((element) => element.id == id);
    completeTasks.removeWhere((element) => element.id == id);
    highPriorityTasks.removeWhere((element) => element.id == id);

    final updatedTask = tasks.map((e) => e.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  void todoTaskIsDone(bool? value, int? index) async {
    if (index == null) return;
    todoTasks[index].isDone = value ?? false;

    int newIndex = tasks.indexWhere(
      (element) => element.id == todoTasks[index].id,
    );
    tasks[newIndex] = todoTasks[index];
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  completeTaskIsDone(bool? value, int? index) async {
    if (index == null) return;
    completeTasks[index].isDone = value ?? false;

    int newIndex = tasks.indexWhere(
      (element) => element.id == completeTasks[index].id,
    );
    tasks[newIndex] = completeTasks[index];
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }

  highPriorityTaskIsDone(bool? value, int? index) async {
    if (index == null) return;
    highPriorityTasks[index].isDone = value ?? false;

    int newIndex = tasks.indexWhere(
      (element) => element.id == highPriorityTasks[index].id,
    );
    tasks[newIndex] = highPriorityTasks[index];
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(tasks));
    _loadTasks();
  }
}
