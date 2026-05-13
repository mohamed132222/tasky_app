import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/task_list_widget.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.pw16,
            vertical: AppSize.ph16,
          ),
          child: Text(
            "Todo Screen",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.ph16,
              horizontal: AppSize.pw16,
            ),
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                  )
                : Consumer<TasksController>(
                    builder: (context, valueController, _) => TaskListWidget(
                      tasks: valueController.todoTasks,
                      emptyMessage: "No Tasks",
                      onDelete: (index) => controller.onDelete(index),
                      onEdit: () {
                        controller.init();
                      },
                      onTap: (value, index) async {
                        controller.doneTask(
                          value,
                          valueController.todoTasks[index!].id,
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
