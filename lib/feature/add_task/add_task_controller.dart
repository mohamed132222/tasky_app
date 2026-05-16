import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/file_manager_storage.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/model/task_model.dart';

class AddTaskController with ChangeNotifier {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isHighPriority = true;

  changeHighPriority(bool value) {
    isHighPriority = value;
    notifyListeners();
  }

  void addTask({required BuildContext context}) async {
    if (formKey.currentState?.validate() ?? false) {
      List<dynamic> taskList = await FileManagerStorage().loadTask();

      TaskModel task = TaskModel(
        id: taskList.length + 1,
        taskName: taskNameController.value.text,
        taskDescription: taskDescriptionController.value.text,
        isHighPriority: isHighPriority,
      );

      taskList.add(task.toJson());
      FileManagerStorage().saveTask(taskList);

      Navigator.of(context).pop(true);
    }
  }
}
