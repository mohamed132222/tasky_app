import 'package:flutter/material.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/widgets/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {
  SliverTaskListWidget({
    super.key,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.emptyMessage,
    required this.tasks,
  });

  List<TaskModel> tasks = [];
  final Function(bool? value, int? index) onTap;
  final Function onEdit;
  final Function(int? index) onDelete;
  int? index;
  String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                emptyMessage ?? "No Data",
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
                onDelete: (index) => onDelete(index),
                onChange: (value) => onTap(value, index),
                onEdit: () => onEdit(),
                taskModel: tasks[index],
              ),
              itemCount: tasks.length,
            ),
          );
  }
}
