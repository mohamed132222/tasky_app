import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/components/task_list_widget.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';

import '../../model/task_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TaskModel> todoTasks = [];

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
          .where((element) => !element.isDone)
          .toList();
    }
    setState(() {
      todoTasks = loadedTasks;

      isLoading = false;
    });
  }

  _onDelete(int? id) async {
    List<TaskModel> allTask = [];
    final taskJson = PreferencesManager().getString("tasks");
    if (taskJson != null) {
      final taskAfterJsonDecode = jsonDecode(taskJson) as List<dynamic>;
      allTask = taskAfterJsonDecode.map((e) => TaskModel.fromJson(e)).toList();
      allTask.removeWhere((element) => element.id == id);
      setState(() {
        todoTasks.removeWhere((element) => element.id == id);
      });
      final updatedTask = allTask.map((e) => e.toJson()).toList();
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
            "Todo Screen",
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
                        todoTasks[index!].isDone = value ?? false;
                      });
                      final allData = PreferencesManager().getString("tasks");
                      if (allData != null) {
                        List<TaskModel> allTasksData =
                            (jsonDecode(allData) as List)
                                .map((e) => TaskModel.fromJson(e))
                                .toList();
                        int newIndex = allTasksData.indexWhere(
                          (element) => element.id == todoTasks[index!].id,
                        );
                        allTasksData[newIndex] = todoTasks[index!];
                        PreferencesManager().setString(
                          "tasks",
                          jsonEncode(allTasksData),
                        );
                        _loadTask();
                      }
                    },
                    tasks: todoTasks,
                  ),
          ),
        ),
      ],
    );
  }
}
