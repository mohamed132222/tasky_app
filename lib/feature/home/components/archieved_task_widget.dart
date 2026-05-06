import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/feature/home/home_controller.dart';

import '../../../core/theme/theme_controller.dart';

class ArchievedTaskWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Achieved Tasks",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.totalDoneTasks} Out of ${controller.totalTasks} Done",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: controller.percentage,
                      backgroundColor: const Color(0xFF6D6D6D),
                      strokeWidth: 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF15B86C),
                      ),
                    ),
                  ),
                  Text(
                    "${(controller.percentage * 100).toInt()}%",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
