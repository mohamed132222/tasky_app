import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasky_app/core/components/sliver_task_list_widget.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/feature/home/components/archieved_task_widget.dart';
import 'package:tasky_app/feature/home/components/high_priority_widget.dart';
import 'package:tasky_app/model/task_model.dart';

import '../../core/services/preferences_manager.dart';
import '../add_task/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? quote = "Default";
  List<TaskModel> tasks = [];
  bool isLoading = false;
  String? imagePath;
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double percentage = 0;

  @override
  initState() {
    super.initState();
    _loadUser();
    _loadTask();
  }

  void _loadUser() async {
    setState(() {
      isLoading = true;
    });

    setState(() {
      username = PreferencesManager().getString(StorageKey.userName);
      quote = PreferencesManager().getString(StorageKey.quote);
      imagePath = PreferencesManager().getString(StorageKey.imagePath);
      isLoading = false;
    });
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });

    final taskJson = PreferencesManager().getString(StorageKey.tasks);

    List<TaskModel> loadedTasks = [];
    if (taskJson != null) {
      final taskListAfterDecoded = jsonDecode(taskJson) as List<dynamic>;
      loadedTasks = taskListAfterDecoded
          .map((e) => TaskModel.fromJson(e))
          .toList();
    }

    setState(() {
      tasks = loadedTasks;
      _calculatePercentage();
      isLoading = false;
    });
  }

  void _calculatePercentage() {
    totalTasks = tasks.length;
    totalDoneTasks = tasks.where((element) => element.isDone).length;
    percentage = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
  }

  Future<void> _isDoneLogic(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercentage();
    });
    final updatedTask = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );
  }

  _onDelete(int? id) {
    final taskJson = PreferencesManager().getString(StorageKey.tasks);
    if (taskJson != null) {
      setState(() {
        tasks.removeWhere((element) => element.id == id);
      });
      final updatedTask = tasks.map((e) => e.toJson()).toList();
      PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.only(top: 8.0, bottom: 22),
                          child: CircleAvatar(
                            backgroundImage: imagePath != null
                                ? FileImage(File(imagePath!))
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
                              "Good Evening ,$username",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              quote ?? "One task at a time. One step closer.",
                              style: Theme.of(context).textTheme.headlineSmall,
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
                      totalTasks: totalTasks,
                      totalDoneTasks: totalDoneTasks,
                      percentage: percentage,
                    ),
                    const SizedBox(height: 8),
                    HighPriorityWidget(
                      refresh: () => _loadTask(),
                      tasks: tasks
                          .where((element) => element.isHighPriority)
                          .toList(),
                      onTap: (value, index) {
                        _isDoneLogic(value, index);
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
              isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFFCFC),
                        ),
                      ),
                    )
                  : SliverTaskListWidget(
                      tasks: tasks,
                      onDelete: (index) => _onDelete(index),
                      onEdit: () {
                        _loadTask();
                      },

                      onTap: (bool? value, int? index) {
                        _isDoneLogic(value, index);
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
              _loadTask();
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
  }
}
