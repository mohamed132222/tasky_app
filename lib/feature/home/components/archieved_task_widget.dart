import 'package:flutter/material.dart';

import '../../../core/theme/theme_controller.dart';

class ArchievedTaskWidget extends StatelessWidget {
  const ArchievedTaskWidget({
    super.key,
    required this.totalTasks,
    required this.totalDoneTasks,
    required this.percentage,
  });

  final int totalTasks;
  final int totalDoneTasks;
  final double percentage;

  @override
  Widget build(BuildContext context) {
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
                "${totalDoneTasks} Out of ${totalTasks} Done",
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
                  value: percentage,
                  backgroundColor: const Color(0xFF6D6D6D),
                  strokeWidth: 4,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF15B86C),
                  ),
                ),
              ),
              Text(
                "${(percentage * 100).toInt()}%",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
