import 'package:daily_planner/model/task.dart';
import 'package:daily_planner/page/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/const.dart';
import '../../data/sqlite.dart';
import '../../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  var formatter = DateFormat('dd/MM/yyyy');

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedLocation;
  String? selectedPerson;
  String? selectedStatus;
  String dayOfWeek = '';
  User user = User(id: 0);

  final taskController = TextEditingController();
  final locationController = TextEditingController();
  final noteController = TextEditingController();

  List<String> weekdays = [
    'Thứ hai',
    'Thứ ba',
    'Thứ tư',
    'Thứ năm',
    'Thứ sáu',
    'Thứ bảy',
    'Chủ nhật'
  ];

  List<String?> persons = [];
  List<String> statuses = ['Tạo mới', 'Thực hiện', 'Thành công', 'Kết thúc'];

  Future<List<User>> _getPersons() async {
    return await _databaseHelper.getAllUserByRole(1);
  }

  update() async {
    List<User> list = await _getPersons();
    for (var u in list) {
      print(u.name.toString());
      persons.add(u.name!);
    }
  }

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser == null) {
      user = User(id: 0);
      print("Không tìm thấy user");
    } else {
      user = User.fromJson(jsonDecode(strUser));
      print("User ID: ${user.id.toString()}");
      print("User: ${user.name.toString()}");
    }
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Task getTask() {
    Task task = Task(
      day: DateFormat('dd/MM/yyyy').format(selectedDate!),
      user: user.id,
      title: taskController.text,
      startTime: startTime?.format(context),
      endTime: endTime?.format(context),
      location: locationController.text,
      preside: selectedPerson,
      note: noteController.text,
      status: selectedStatus,
      approver: '',
    );

    return task;
  }

  @override
  void initState() {
    super.initState();
    update();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Công việc mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chọn ngày
              const Text("Thứ ngày:", style: label),
              Row(
                children: [
                  Text(
                      selectedDate != null
                          ? "${weekdays[selectedDate!.weekday - 1]}, ${formatter.format(selectedDate!)}"
                          : 'Chọn ngày',
                      style: text),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text("Chọn ngày"),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Nội dung công việc
              const Text("Nội dung công việc:", style: label),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung công việc',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Thời gian bắt đầu
              const Text("Thời gian bắt đầu:", style: label),
              Row(
                children: [
                  Text(
                      startTime != null
                          ? startTime!.format(context)
                          : 'Chọn thời gian',
                      style: label),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, true),
                    child: const Text("Chọn giờ bắt đầu"),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Thời gian kết thúc
              const Text("Thời gian kết thúc:", style: label),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      endTime != null
                          ? endTime!.format(context)
                          : 'Chọn thời gian',
                      style: label),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => _selectTime(context, false),
                    child: const Text("Chọn giờ kết thúc"),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Địa điểm
              const Text("Địa điểm:", style: label),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'Nhập địa điểm (VD: online)',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Chủ trì
              Row(
                children: [
                  const Text("Chủ trì:", style: label),
                  const Spacer(),
                  DropdownButton<String>(
                    value: selectedPerson,
                    hint: const Text('Chọn người chủ trì'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPerson = newValue;
                      });
                    },
                    items:
                        persons.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: text,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Ghi chú
              const Text("Ghi chú:", style: label),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: 'Nhập ghi chú (nếu có)',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              // Kiểm duyệt
              Row(
                children: [
                  const Text("Trạng thái:", style: label),
                  const Spacer(),
                  DropdownButton<String>(
                    value: selectedStatus,
                    hint: const Text('Chọn trạng thái kiểm duyệt'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    },
                    items:
                        statuses.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: text,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),
              // Nút lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.black.withOpacity(0.5),
                    elevation: 8,
                  ),
                  onPressed: () async {
                    Task newTask = getTask();
                    print(newTask.title);
                    print(newTask.user);

                    await _databaseHelper.insertTask(newTask);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    "Tạo mới",
                    style: textButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
