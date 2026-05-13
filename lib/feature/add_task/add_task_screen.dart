import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/core/widgets/custom_text_form_field.dart';
import 'package:tasky_app/feature/add_task/add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext _) {
    print("build in add task");
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      builder: (context, _) {
        final controller = context.read<AddTaskController>();
        return Scaffold(
          appBar: AppBar(title: const Text("New Task")),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.pw16,
                vertical: AppSize.ph8,
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              title: "Task Name",
                              controller: controller.taskNameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter task name";
                                }
                                return null;
                              },
                              hintText: "Finish UI design for login screen",
                            ),
                            SizedBox(height: AppSize.ph20),
                            CustomTextFormField(
                              title: "Task Description",
                              controller: controller.taskDescriptionController,

                              hintText:
                                  "Finish onboarding UI and hand off to devs by Thursday.",
                              maxline: 5,
                            ),
                            SizedBox(height: AppSize.ph20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "High Priority",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Consumer<AddTaskController>(
                                  builder: (context, value, _) {
                                    print("build in consumer");
                                    return Switch(
                                      value: value.isHighPriority,
                                      onChanged: (value) =>
                                          controller.changeHighPriority(value),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    ElevatedButton.icon(
                      onPressed: () => controller.addTask(context: context),
                      label: const Text("Add Task"),
                      icon: Icon(Icons.add, size: AppSize.r18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
