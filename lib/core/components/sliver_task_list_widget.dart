import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/task_item_widget.dart';
import 'package:tasky_app/feature/home/home_controller.dart';

class SliverTaskListWidget extends StatelessWidget {
  SliverTaskListWidget({super.key});

  int? index;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        final controller = context.read<HomeController>();
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFFFFCFC),
                    ),
                  ),
                ),
              )
            : SliverPadding(
                padding: EdgeInsets.only(bottom: 60),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemBuilder: (context, index) => TaskItemWidget(
                    onDelete: (index) => controller.onDelete(index),
                    onChange: (value) => controller.isDoneLogic(value, index),
                    onEdit: () => controller.loadTask(),
                    taskModel: tasks[index],
                  ),
                  itemCount: tasks.length,
                ),
              );
      },
    );
  }
}
