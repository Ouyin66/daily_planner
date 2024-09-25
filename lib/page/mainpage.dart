import 'package:daily_planner/config/const.dart';
import 'package:daily_planner/page/calendar/calendar.dart';
import 'package:daily_planner/page/notification/notification.dart';
import 'package:daily_planner/page/setting/setting.dart';
import 'package:daily_planner/page/task/tasklist.dart';
import 'package:flutter/material.dart';

import 'task/addtask.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const TaskWidget(),
    const CalendarWidget(),
    const NotificationWidget(),
    const SettingWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: branchColor2,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 20,
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: branchColor, width: 2.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: const EdgeInsets.all(10),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildNavItem(Icons.work_outline, 0),
                      _buildNavItem(Icons.calendar_month_outlined, 1),
                      const SizedBox(
                          width: 60), // Chỗ trống cho FloatingActionButton
                      _buildNavItem(Icons.notifications_none_rounded, 2),
                      _buildNavItem(Icons.settings, 3),
                    ],
                  ),
                  Positioned(
                    child: Transform.scale(
                      scale: 1.3, // Điều chỉnh giá trị này để tăng kích thước
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddTaskWidget()),
                          );
                        },
                        backgroundColor: light,
                        shape: const CircleBorder(), // Đảm bảo hình tròn
                        child: const Icon(
                          Icons.add,
                          size: 40,
                          color: branchColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {Color? color}) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color: color ?? (_selectedIndex == index ? light : light),
          size: 30,
        ),
      ),
    );
  }
}
