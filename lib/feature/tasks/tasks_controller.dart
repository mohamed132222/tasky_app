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
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double percentage = 0;
  init() {
    _loadTasks();
  }

  void _loadTasks() async {
    isLoading = true;

    final taskJson = PreferencesManager().getString(StorageKey.tasks);

    if (taskJson != null) {
      final taskListAfterDecoded = jsonDecode(taskJson) as List<dynamic>;
      tasks = taskListAfterDecoded.map((e) => TaskModel.fromJson(e)).toList();
      _loadData();
    }

    isLoading = false;
    notifyListeners();
  }

  onDelete(int? id) async {
    tasks.removeWhere((element) => element.id == id);
    _loadData();
    _calculatePercentage();

    // todoTasks.removeWhere((element) => element.id == id);
    // completeTasks.removeWhere((element) => element.id == id);
    // highPriorityTasks.removeWhere((element) => element.id == id);
    final updatedTask = tasks.map((e) => e.toJson()).toList();
    PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));

    notifyListeners();
  }

  Future<void> doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((element) => element.id == id);

    tasks[index].isDone = value ?? false;
    _loadData();
    _calculatePercentage();

    final updatedTask = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );
    notifyListeners();
  }

  void _calculatePercentage() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((element) => element.isDone).length;
    percentage = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
  }

  void _loadData() {
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completeTasks = tasks.where((element) => element.isDone).toList();
    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();
    highPriorityTasks = highPriorityTasks.reversed.toList();
    _calculatePercentage();
  }
}
