import 'package:daily_planner/config/const.dart';
import 'package:daily_planner/model/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sqlite.dart';
import '../../model/task.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Task> tasks = [];
  User user = User(id: 0);

  Future<List<Task>> _getTasks(int id) async {
    return await _databaseHelper.getTasksOfUser(id);
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser == null) {
      user = User(id: 0);
      print("Không tìm thấy user");
    } else {
      user = User.fromJson(jsonDecode(strUser));
      tasks = await _getTasks(user.id!);
      print(tasks);
      if (tasks.isNotEmpty) {
        print(tasks.first.title.toString());
      } else {
        print("Không tìm thấy danh sách");
      }
      print("User ID: ${user.id.toString()}");
      print("User: ${user.name.toString()}");
    }
    setState(() {});
  }

  void _loadTasks() async {
    tasks = await _getTasks(user.id!); // Tải lại danh sách công việc cho user
    setState(() {}); // Cập nhật trạng thái
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 60, 10, 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Danh sách công việc",
                style: title2,
              ),
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) =>
                    itemTaskView(tasks[index], context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTaskView(Task task, BuildContext context) {
    // Thứ ngày
    DateTime day = DateFormat("dd/MM/yyyy").parse(task.day!);
    List<String> weekdays = [
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
      'Chủ nhật',
    ];
    String dayOfWeek = weekdays[day.weekday - 1];

    // Chuyển TEXT -> Time
    // List<String> partsOfSTime = task.startTime.toString().split(":");
    // TimeOfDay newStartTime = TimeOfDay(
    //   hour: int.parse(partsOfSTime[0]),
    //   minute: int.parse(partsOfSTime[1]),
    // );

    // List<String> partsOfETime = task.endTime.toString().split(":");
    // TimeOfDay newEndTime = TimeOfDay(
    //   hour: int.parse(partsOfETime[0]),
    //   minute: int.parse(partsOfETime[1]),
    // );

    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4), // Thay đổi vị trí của bóng đổ
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${dayOfWeek}, ${task.day}"),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await _databaseHelper.deleteTask(task.id!);
                      _loadTasks();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text(task.title.toString()),
              Text(
                  "${task.startTime.toString()} -> ${task.endTime.toString()}"),
              Text("Địa điểm: ${task.location}"),
              Text("Chủ trì: ${task.preside}"),
              Text(task.note.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
