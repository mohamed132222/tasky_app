import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/sliver_task_list_widget.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/feature/home/components/archieved_task_widget.dart';
import 'package:tasky_app/feature/home/components/high_priority_widget.dart';
import 'package:tasky_app/feature/home/home_controller.dart';

import '../add_task/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print("build");
    return ChangeNotifierProvider(
      create: (context) => HomeController()..init(),
      child: Consumer<HomeController>(
        builder: (context, value, child) {
          final HomeController controller = context.read<HomeController>();
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 22,
                                ),
                                child: CircleAvatar(
                                  backgroundImage: value.imagePath != null
                                      ? FileImage(File(value.imagePath!))
                                      : const AssetImage(
                                          "assets/images/Leading element.png",
                                        ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good Evening ,${value.username}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium,
                                  ),
                                  Text(
                                    value.quote ??
                                        "One task at a time. One step closer.",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Yuhuu ,Your work Is",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Row(
                            children: [
                              Text(
                                "almost done !",
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              const SizedBox(width: 8),
                              CustomSvgPicture(
                                imgPath: "wave_hand",
                                withFilterColor: false,
                                width: 28,
                                height: 28,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ArchievedTaskWidget(
                            totalTasks: value.totalTasks,
                            totalDoneTasks: value.totalDoneTasks,
                            percentage: value.percentage,
                          ),
                          const SizedBox(height: 8),
                          HighPriorityWidget(
                            refresh: () => controller.loadTask(),
                            tasks: value.tasks
                                .where((element) => element.isHighPriority)
                                .toList(),
                            onTap: (value, index) {
                              controller.isDoneLogic(value, index);
                            },
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16, top: 24),
                            child: Text(
                              "My Tasks",
                              style: Theme.of(
                                context,
                              ).textTheme.displayMedium?.copyWith(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    value.isLoading
                        ? const SliverToBoxAdapter(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFFCFC),
                              ),
                            ),
                          )
                        : SliverTaskListWidget(
                            tasks: value.tasks,
                            onDelete: (index) => controller.onDelete(index),
                            onEdit: () {
                              controller.loadTask();
                            },

                            onTap: (bool? value, int? index) {
                              controller.isDoneLogic(value, index);
                            },
                          ),
                  ],
                ),
              ),
            ),

            floatingActionButton: SizedBox(
              height: 42,

              child: FloatingActionButton.extended(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTaskScreen()),
                  );
                  if (result != null && result) {
                    controller.loadTask();
                  }
                },
                backgroundColor: const Color(0xFF15B86C),
                foregroundColor: const Color(0xFFFFFCFC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                label: const Text("Add New Task"),
                icon: const Icon(Icons.add, size: 20),
              ),
            ),
          );
        },
      ),
    );
  }
}
