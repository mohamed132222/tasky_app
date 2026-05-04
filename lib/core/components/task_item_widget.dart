import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/enums/popup_item_actions_enum.dart';
import 'package:tasky_app/core/theme/theme_controller.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/model/task_model.dart';

import '../services/preferences_manager.dart';
import '../widgets/custom_check_box.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
    required this.onChange,
    required this.onEdit,
    required this.onDelete,
  });

  final TaskModel taskModel;
  final Function(bool? value) onChange;
  final Function() onEdit;
  final Function(int? index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
        ),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        children: [
          CustomCheckBox(
            value: taskModel.isDone,
            onTap: (value) => onChange(value),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  taskModel.taskName,
                  maxLines: 1,
                  style: taskModel.isDone
                      ? Theme.of(context).textTheme.titleSmall
                      : Theme.of(context).textTheme.titleMedium,
                ),
                if (taskModel.taskDescription.isNotEmpty)
                  Text(
                    taskModel.taskDescription,
                    maxLines: 1,

                    style: taskModel.isDone
                        ? Theme.of(context).textTheme.titleSmall
                        : Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
          ),
          PopupMenuButton<PopupItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? taskModel.isDone
                        ? Color(0xFFA0A0A0)
                        : Color(0xFFFFFCFC)
                  : taskModel.isDone
                  ? Color(0xFF6A6A6A)
                  : Color(0xFF3A4640),
            ),
            onSelected: (value) async {
              switch (value) {
                case PopupItemActionsEnum.isMarkDone:
                  onChange(!taskModel.isDone);
                case PopupItemActionsEnum.edit:
                  final result = await _showModalBottomSheet(
                    context,
                    taskModel,
                  );
                  if (result == true) {
                    onEdit();
                  }
                case PopupItemActionsEnum.delete:
                  _showDialog(context);
              }
            },
            itemBuilder: (context) => PopupItemActionsEnum.values
                .map((e) => PopupMenuItem(value: e, child: Text(e.name)))
                .toList(),
          ),
        ],
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancle"),
          ),
          TextButton(
            onPressed: () {
              onDelete(taskModel.id);
              Navigator.pop(context);
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.red),
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(
    BuildContext context,
    TaskModel taskModel,
  ) {
    final TextEditingController taskNameController = TextEditingController(
      text: taskModel.taskName,
    );
    bool isHighPriority = taskModel.isHighPriority;
    final TextEditingController taskDescriptionController =
        TextEditingController(text: taskModel.taskDescription);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showModalBottomSheet<bool?>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          title: "Task Name",
                          controller: taskNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter task name";
                            }
                            return null;
                          },
                          hintText: "Finish UI design for login screen",
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          title: "Task Description",
                          controller: taskDescriptionController,

                          hintText:
                              "Finish onboarding UI and hand off to devs by Thursday.",
                          maxline: 5,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High Priority",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              value: isHighPriority,
                              onChanged: (value) {
                                setState(() {
                                  isHighPriority = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width, 42),
                  ),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      List<dynamic> taskList = [];
                      final taskJson = PreferencesManager().getString("tasks");
                      if (taskJson != null) {
                        taskList = jsonDecode(taskJson);
                      }
                      final item = taskList.firstWhere(
                        (element) => element['id'] == taskModel.id,
                      );
                      final index = taskList.indexOf(item);
                      TaskModel newModel = TaskModel(
                        id: taskModel.id,
                        taskName: taskNameController.value.text,
                        taskDescription: taskDescriptionController.value.text,
                        isHighPriority: taskModel.isHighPriority,
                        isDone: taskModel.isDone,
                      );
                      taskList[index] = newModel;
                      await PreferencesManager().setString(
                        "tasks",
                        jsonEncode(taskList),
                      );
                      Navigator.of(context).pop(true);
                    }
                  },
                  label: const Text("Edit Task"),
                  icon: const Icon(Icons.edit, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
