import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

import '../../core/components/task_list_widget.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

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
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                  )
                : Consumer<TasksController>(
                    builder: (context, valueController, _) {
                      return TaskListWidget(
                        tasks: valueController.completeTasks,
                        emptyMessage: "No Tasks",
                        onDelete: (index) => controller.onDelete(index),
                        onEdit: () {
                          controller.init();
                        },
                        onTap: (value, index) async {
                          controller.doneTask(
                            value,
                            valueController.completeTasks[index!].id,
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
