import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/widgets/custom_check_box.dart';
import 'package:tasky_app/core/widgets/custom_svg_picture.dart';
import 'package:tasky_app/feature/home/home_controller.dart';

import '../../../core/theme/theme_controller.dart';
import '../../tasks/high_priority_screen.dart';

class HighPriorityWidget extends StatelessWidget {
  const HighPriorityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        final taskList = controller.tasks;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeController.isDark()
                  ? Colors.transparent
                  : Color(0xFFD1DAD6),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        "High Priority Tasks",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          color: Color(0xFF15B86C),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          taskList
                                  .map((e) => e.isHighPriority)
                                  .toList()
                                  .length >
                              4
                          ? 4
                          : taskList
                                .map((e) => e.isHighPriority)
                                .toList()
                                .length,
                      itemBuilder: (context, index) {
                        taskList.reversed
                            .where((element) => element.isHighPriority)
                            .toList();
                        final task = taskList[index];
                        return Row(
                          children: [
                            CustomCheckBox(
                              value: task.isDone,
                              onTap: (value) {
                                final index = taskList.indexWhere(
                                  (element) => element.id == task.id,
                                );
                                controller.isDoneLogic(value, index);
                              },
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                task.taskName,
                                maxLines: 1,
                                style: task.isDone
                                    ? Theme.of(context).textTheme.titleSmall
                                    : Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HighPriorityScreen(),
                    ),
                  );
                  controller.loadTask();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(color: Color(0xFF6E6E6E), width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomSvgPicture(
                    imgPath: "arrow_up_right",
                    withFilterColor: false,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
