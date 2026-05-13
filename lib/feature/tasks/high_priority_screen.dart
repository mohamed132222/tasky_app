import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

import '../../core/components/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

    return Scaffold(
      appBar: AppBar(title: Text("High Priority Screen")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.pw16,
          vertical: AppSize.ph16,
        ),
        child: controller.isLoading
            ? Center(child: CircularProgressIndicator(color: Color(0xFFFFFCFC)))
            : Consumer<TasksController>(
                builder: (context, valueController, _) {
                  return TaskListWidget(
                    emptyMessage: "No Tasks",
                    onDelete: (index) => controller.onDelete(index),
                    onEdit: () {
                      controller.init();
                    },
                    onTap: (value, index) async {
                      controller.doneTask(
                        value,
                        valueController.highPriorityTasks[index!].id,
                      );
                    },
                    tasks: valueController.highPriorityTasks,
                  );
                },
              ),
      ),
    );
  }
}
