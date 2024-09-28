import 'package:flutter/services.dart';
import '../model/task.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class ReadDataTask {
  Future<List<Task>> loadData() async {
    var data = await rootBundle.loadString("assets/json/task.json");
    var dataJson = jsonDecode(data);

    return (dataJson['task'] as List).map((p) => Task.fromJson(p)).toList();
  }

  Future<void> insertUserToDB(Database db, List<Task> list) async {
    for (var customer in list) {
      await db.insert(
        'task',
        customer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
