import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config/const.dart';
import '../../data/sqlite.dart';
import '../../model/task.dart';
import '../../model/user.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  var formatter = DateFormat('dd/MM/yyyy');

  DateTime _selectedDay = DateTime.now(); // Initialize selected day
  DateTime _focusedDay = DateTime.now(); // Initialize focused day
  Map<DateTime, List<Task>> _tasksByDate = {};
  List<Task> tasks = [];
  User user = User(id: 0);

  Future<List<Task>> _getTasks(int id) async {
    return await _databaseHelper.getTasksOfUser(id);
  }

  Future<void> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser == null) {
      user = User(id: 0);
      print("Không tìm thấy user");
    } else {
      user = User.fromJson(jsonDecode(strUser));
      tasks = await _getTasks(user.id!);
      print("User ID: ${user.id}");
      print("User: ${user.name}");
      _tasksByDate = _groupTasksByDate(tasks);
      print("Grouped tasks by date: ${_tasksByDate}");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    getUser();
  }

  Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
    final Map<DateTime, List<Task>> tasksByDate = {};

    for (var task in tasks) {
      if (task.day != null) {
        // Phân tích chuỗi ngày với định dạng 'dd/MM/yyyy'
        DateTime date = DateFormat('dd/MM/yyyy').parse(task.day!);
        // Chỉ lấy ngày, tháng, năm
        date = DateTime(date.year, date.month, date.day);

        // In ra ngày đã phân tích
        print("Grouped date: ${date.toString()}");

        // Kiểm tra xem ngày đã có trong map hay chưa
        if (tasksByDate[date] == null) {
          tasksByDate[date] = [];
        }
        // Thêm tác vụ vào danh sách theo ngày
        tasksByDate[date]!.add(task);
      }
    }
    return tasksByDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              tasks.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedDay = DateTime(_selectedDay.year,
                                    _selectedDay.month, _selectedDay.day);
                              });
                            }
                          },
                          eventLoader: (day) {
                            DateTime normalizedDay =
                                DateTime(day.year, day.month, day.day);

                            final events = _tasksByDate[normalizedDay] ?? [];
                            // print(
                            //     "Events for ${formatter.format(normalizedDay)}: ${events.length}");
                            return events;
                          },
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: branchColor,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: branchColor2,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Công việc cho ${formatter.format(_selectedDay)}:',
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _tasksByDate[_selectedDay]?.length ?? 0,
                          itemBuilder: (context, index) {
                            final task = _tasksByDate[_selectedDay]![index];
                            return itemTaskView(task, context);
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemTaskView(Task task, BuildContext context) {
    // Thứ ngày
    DateTime day = formatter.parse(task.day!);
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${dayOfWeek}, ${task.day}"),
              Text(task.title.toString()),
              Text("${task.startTime} -> ${task.endTime}"),
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
