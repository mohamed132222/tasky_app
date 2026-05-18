import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/hive_manager_storage.dart';
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

    tasks = HiveManagerStorage().loadTask();
    //  tasks = taskData.map((e) => TaskModel.fromJson(e)).toList();
    _loadData();
    _calculatePercentage();

    isLoading = false;
    notifyListeners();
  }

  onDelete(int? id) {
    tasks.removeWhere((element) => element.id == id);
    _loadData();
    _calculatePercentage();

    // todoTasks.removeWhere((element) => element.id == id);
    // completeTasks.removeWhere((element) => element.id == id);
    // highPriorityTasks.removeWhere((element) => element.id == id);
    // final updatedTask = tasks.map((e) => e.toJson()).toList();
    HiveManagerStorage().saveTask(tasks);

    notifyListeners();
  }

  Future<void> doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((element) => element.id == id);

    tasks[index].isDone = value ?? false;
    _loadData();
    _calculatePercentage();

    // final updatedTask = tasks.map((e) => e.toJson()).toList();
    HiveManagerStorage().saveTask(tasks);

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

  void clearTask() {
    _loadTasks();
  }
}
