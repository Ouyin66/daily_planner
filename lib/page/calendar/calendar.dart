import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/const.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime date = DateTime.now();
  String dayOfWeek = "";
  var formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    List<String> weekdays = [
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
      'Chủ nhật'
    ];
    dayOfWeek = weekdays[date.weekday - 1];
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
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "${dayOfWeek},",
                  style: title2,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  formatter.format(date),
                  style: text,
                ),
              ),
              Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text("Thứ 4, 25//09/2024"),
                            Text(
                              "Làm bài kiểm tra chất lượng",
                            ),
                            Text("Địa điểm: Online"),
                            Text("Chủ trì: Hữu Nghĩa"),
                          ],
                        ),
                        Container(
                          child: Text("8:00"),
                        ),
                      ],
                    ),
                    Text("Ghi chú: Làm bài testaqsdwasdwasda")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
