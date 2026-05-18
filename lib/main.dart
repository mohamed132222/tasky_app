import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/services/hive_manager_storage.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';
import 'package:tasky_app/core/theme/light_theme.dart';
import 'package:tasky_app/feature/navigation/main_screen.dart';
import 'package:tasky_app/feature/tasks/tasks_controller.dart';
import 'package:tasky_app/feature/welcome/welcome_screen.dart';

import 'core/constant/storage_key.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager().init();
  String? username = PreferencesManager().getString(StorageKey.userName);
  await HiveManagerStorage().init();
  ThemeController().init();
  runApp(TaskyApp(username: username));
}

class TaskyApp extends StatelessWidget {
  TaskyApp({super.key, required this.username});

  String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      builder: (context, ThemeMode value, child) {
        return ChangeNotifierProvider<TasksController>(
          create: (_) => TasksController()..init(),
          child: ScreenUtilInit(
            designSize: Size(375, 809),
            minTextAdapt: true,
            builder: (context, child) => MaterialApp(
              theme: lighTheme,
              darkTheme: darkTheme,
              themeMode: value,
              debugShowCheckedModeBanner: false,
              home: username == null ? WelcomeScreen() : MainScreen(),
            ),
          ),
        );
      },
      valueListenable: ThemeController.themeNotifier,
    );
  }
}
