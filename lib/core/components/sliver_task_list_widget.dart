import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/task_item_widget.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

class SliverTaskListWidget extends StatelessWidget {
  SliverTaskListWidget({super.key});

  int? index;

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (context, TasksController controller, child) {
        final controller = context.read<TasksController>();
        final tasks = controller.tasks;

        return controller.isLoading
            ? const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFFCFC)),
                ),
              )
            : tasks.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "No Data",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.only(bottom: 60.h),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) => TaskItemWidget(
                    onDelete: (index) => controller.onDelete(index),
                    onChange: (value) =>
                        controller.doneTask(value, tasks[index].id),
                    onEdit: () => controller.init(),
                    taskModel: tasks[index],
                  ),
                  itemCount: tasks.length,
                ),
              );
      },
    );
  }
}
