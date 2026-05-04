import 'package:flutter/material.dart';
import 'package:tasky_app/model/task_model.dart';
import 'package:tasky_app/widgets/task_item_widget.dart';

class TaskListWidget extends StatelessWidget {
  TaskListWidget({
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
        ? Center(
            child: Text(
              emptyMessage ?? "No Data",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 8),
            padding: EdgeInsets.only(bottom: 60),
            itemBuilder: (context, index) => TaskItemWidget(
              taskModel: tasks[index],
              onDelete: (index) => onDelete(index),
              onEdit: () => onEdit(),
              onChange: (value) => onTap(value, index),
            ),
            itemCount: tasks.length,
          );
  }
}
