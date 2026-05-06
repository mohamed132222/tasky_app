import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

import '../../core/components/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return ChangeNotifierProvider<TasksController>(
      create: (_) => TasksController()..init(),
      builder: (context, _) {
        final controller = context.read<TasksController>();
        return Scaffold(
          appBar: AppBar(title: Text("High Priority Screen")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                  )
                : Consumer<TasksController>(
                    builder: (context, value, _) {
                      return TaskListWidget(
                        emptyMessage: "No Tasks",
                        onDelete: (index) => controller.onDelete(index),
                        onEdit: () {
                          controller.init();
                        },
                        onTap: (value, index) async {
                          controller.highPriorityTaskIsDone(value, index);
                        },
                        tasks: value.highPriorityTasks,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
