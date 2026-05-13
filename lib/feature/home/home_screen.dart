import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/components/sliver_task_list_widget.dart';
import 'package:tasky_app/core/constant/app_size.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/feature/home/components/archieved_task_widget.dart';
import 'package:tasky_app/feature/home/components/high_priority_widget.dart';
import 'package:tasky_app/feature/home/home_controller.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';

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
    return ChangeNotifierProvider<HomeController>(
      create: (context) => HomeController()..init(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.ph16,
              horizontal: AppSize.pw16,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: AppSize.ph8,
                              bottom: AppSize.ph22,
                            ),
                            child: Selector<HomeController, String?>(
                              selector: (context, controller) =>
                                  controller.imagePath,
                              builder: (context, imagePath, child) =>
                                  CircleAvatar(
                                    backgroundImage: imagePath != null
                                        ? FileImage(File(imagePath))
                                        : const AssetImage(
                                            "assets/images/Leading element.png",
                                          ),
                                  ),
                            ),
                          ),
                          SizedBox(width: AppSize.pw8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Selector<HomeController, String?>(
                                selector:
                                    (
                                      BuildContext context,
                                      HomeController controller,
                                    ) => controller.username,
                                builder: (context, username, child) => Text(
                                  "Good Evening ,$username",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),
                              Selector<HomeController, String?>(
                                selector: (context, controller) =>
                                    controller.quote,
                                builder: (context, quote, child) => Text(
                                  quote ??
                                      "One task at a time. One step closer.",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.ph16),
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
                          SizedBox(width: AppSize.pw8),
                          CustomSvgPicture(
                            imgPath: "wave_hand",
                            withFilterColor: false,
                            width: AppSize.pw28,
                            height: AppSize.ph28,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.ph16),
                      ArchievedTaskWidget(),
                      SizedBox(height: AppSize.ph8),
                      HighPriorityWidget(),
                      SizedBox(height: AppSize.ph24),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: AppSize.ph16,
                          top: AppSize.ph24,
                        ),
                        child: Text(
                          "My Tasks",
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(fontSize: AppSize.f20),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverTaskListWidget(),
              ],
            ),
          ),
        ),

        floatingActionButton: SizedBox(
          height: AppSize.ph42,

          child: Builder(
            builder: (context) => FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskScreen()),
                );
                if (result != null && result) {
                  context.read<TasksController>().init();
                }
              },
              backgroundColor: const Color(0xFF15B86C),
              foregroundColor: const Color(0xFFFFFCFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.r20),
              ),
              label: const Text("Add New Task"),
              icon: Icon(Icons.add, size: AppSize.r20),
            ),
          ),
        ),
      ),
    );
  }
}
