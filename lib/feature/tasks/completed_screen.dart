import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';

import '../../core/components/task_list_widget.dart';
import '../../model/task_model.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<TaskModel> completedTasks = [];

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
          .where((element) => element.isDone == true)
          .toList();
    }
    setState(() {
      completedTasks = loadedTasks;

      isLoading = false;
    });
  }

  Future<void> _onDelete(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;
    final taskJson = PreferencesManager().getString("tasks");
    if (taskJson != null) {
      final taskAfterDecode = jsonDecode(taskJson) as List<dynamic>;
      tasks = taskAfterDecode.map((e) => TaskModel.fromJson(e)).toList();
      tasks.removeWhere((element) => element.id == id);
      setState(() {
        completedTasks.removeWhere((element) => element.id == id);
      });
      final updatedTask = tasks.map((e) => e.toJson()).toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Completed Screen",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                  )
                : TaskListWidget(
                    emptyMessage: "No Tasks",
                    onDelete: (index) => _onDelete(index),
                    onEdit: () {
                      _loadTask();
                    },
                    onTap: (value, index) async {
                      setState(() {
                        completedTasks[index!].isDone = value ?? false;
                      });
                      final allData = PreferencesManager().getString("tasks");
                      if (allData != null) {
                        final List<TaskModel> allTaskData =
                            (jsonDecode(allData) as List)
                                .map((e) => TaskModel.fromJson(e))
                                .toList();
                        int newIndex = allTaskData.indexWhere(
                          (element) => element.id == completedTasks[index!].id,
                        );
                        allTaskData[newIndex] = completedTasks[index!];
                        PreferencesManager().setString(
                          "tasks",
                          jsonEncode(allTaskData),
                        );
                        _loadTask();
                      }
                    },
                    tasks: completedTasks,
                  ),
          ),
        ),
      ],
    );
  }
}
