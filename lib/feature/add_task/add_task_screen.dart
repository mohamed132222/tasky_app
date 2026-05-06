import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/model/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //TODO: dispose controllers
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHighPriority = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    taskNameController.dispose();
    taskDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
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
                    if (_formKey.currentState?.validate() ?? false) {
                      //save data {shared preferences}
                      //check by key{tasks}->String?
                      final taskJson = PreferencesManager().getString(
                        StorageKey.tasks,
                      );
                      List<dynamic> taskList = [];
                      if (taskJson != null) {
                        taskList = jsonDecode(taskJson);
                      }
                      TaskModel task = TaskModel(
                        id: taskList.length + 1,
                        taskName: taskNameController.value.text,
                        taskDescription: taskDescriptionController.value.text,
                        isHighPriority: isHighPriority,
                      );

                      taskList.add(task.toJson());
                      await PreferencesManager().setString(
                        StorageKey.tasks,
                        jsonEncode(taskList),
                      );
                      Navigator.of(context).pop(true);
                    }
                  },
                  label: const Text("Add Task"),
                  icon: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
