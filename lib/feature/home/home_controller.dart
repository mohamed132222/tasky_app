import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';

import '../../model/task_model.dart';

class HomeController with ChangeNotifier {
  String? username = "Default";
  String? quote = "Default";
  List<TaskModel> tasks = [];
  bool isLoading = false;
  String? imagePath;
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double percentage = 0;

  void init() {
    loadUserData();
    loadTask();
  }

  void loadUserData() async {
    isLoading = true;

    username = PreferencesManager().getString(StorageKey.userName);
    quote = PreferencesManager().getString(StorageKey.quote);
    imagePath = PreferencesManager().getString(StorageKey.imagePath);
    isLoading = false;
    notifyListeners();
  }

  void loadTask() async {
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
    calculatePercentage();
    isLoading = false;
    notifyListeners();
  }

  void calculatePercentage() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((element) => element.isDone).length;
    percentage = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
  }

  Future<void> isDoneLogic(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercentage();

    final updatedTask = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );
    notifyListeners();
  }

  void onDelete(int? id) {
    final taskJson = PreferencesManager().getString(StorageKey.tasks);
    if (taskJson != null) {
      tasks.removeWhere((element) => element.id == id);

      final updatedTask = tasks.map((e) => e.toJson()).toList();
      PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    }
    notifyListeners();
  }
}
