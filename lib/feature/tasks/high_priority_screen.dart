import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/components/task_list_widget.dart';
import '../../core/services/preferences_manager.dart';
import '../../model/task_model.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> highPriorityTask = [];

  bool isLoading = false;

  @override
  initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });

    final taskJson = PreferencesManager().getString("tasks");
    List<TaskModel> loadedTasks = [];
    if (taskJson != null) {
      final taskListAfterDecoded = jsonDecode(taskJson) as List<dynamic>;
      loadedTasks = taskListAfterDecoded
          .map((e) => TaskModel.fromJson(e))
          .where((element) => element.isHighPriority)
          .toList();
    }
    setState(() {
      highPriorityTask = loadedTasks.reversed.toList();
      isLoading = false;
    });
  }

  _onDelete(int? id) async {
    List<TaskModel> allTask = [];
    if (id == null) return;
    final taskJson = PreferencesManager().getString("tasks");
    if (taskJson != null) {
      final taskJsonAfterDecode = jsonDecode(taskJson) as List<dynamic>;
      allTask = taskJsonAfterDecode.map((e) => TaskModel.fromJson(e)).toList();
      allTask.removeWhere((element) => element.id == id);
      setState(() {
        highPriorityTask.removeWhere((element) => element.id == id);
      });
      final updatedTask = allTask.map((e) => e.toJson()).toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : TaskListWidget(
                emptyMessage: "No Tasks",
                onDelete: (index) => _onDelete(index),
                onEdit: () {
                  _loadTask();
                },
                onTap: (value, index) async {
                  setState(() {
                    highPriorityTask[index!].isDone = value ?? false;
                  });
                  final allData = PreferencesManager().getString("tasks");
                  if (allData != null) {
                    List<TaskModel> allTasksData = (jsonDecode(allData) as List)
                        .map((e) => TaskModel.fromJson(e))
                        .toList();
                    int newIndex = allTasksData.indexWhere(
                      (element) => element.id == highPriorityTask[index!].id,
                    );
                    allTasksData[newIndex] = highPriorityTask[index!];
                    PreferencesManager().setString(
                      "tasks",
                      jsonEncode(allTasksData),
                    );
                    _loadTask();
                  }
                },
                tasks: highPriorityTask,
              ),
      ),
    );
  }
}
