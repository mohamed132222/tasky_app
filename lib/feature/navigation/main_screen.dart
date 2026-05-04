import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/theme/theme_controller.dart';
import 'package:tasky_app/feature/home/home_screen.dart';
import 'package:tasky_app/feature/profile/profile_screen.dart';
import 'package:tasky_app/feature/tasks/todo_screen.dart';
import '../tasks/completed_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _tabs = [
    HomeScreen(),
    TodoScreen(),
    CompletedScreen(),
    ProfileScreen(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgPicture(path: "assets/images/home.svg", index: 0),

            label: "home",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture(path: "assets/images/todo.svg", index: 1),

            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/images/completed.svg",
              colorFilter: _currentIndex == 2
                  ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
                  : ColorFilter.mode(
                      ThemeController.isDark()
                          ? Color(0xFFC6C6C6)
                          : Color(0xFF3A4640),
                      BlendMode.srcIn,
                    ),
            ),

            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture(path: "assets/images/profile.svg", index: 3),
            label: "profile",
          ),
        ],
      ),
      body: SafeArea(child: _tabs[_currentIndex]),
    );
  }

  SvgPicture _buildSvgPicture({required String path, required int index}) {
    return SvgPicture.asset(
      path,
      colorFilter: _currentIndex == index
          ? ColorFilter.mode(Color(0xFF15B86C), BlendMode.srcIn)
          : ColorFilter.mode(
              ThemeController.isDark() ? Color(0xFFC6C6C6) : Color(0xFF3A4640),
              BlendMode.srcIn,
            ),
    );
  }
}
