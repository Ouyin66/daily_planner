import 'package:flutter/services.dart';

import '../model/user.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class ReadDataUser {
  Future<List<User>> loadData() async {
    var data = await rootBundle.loadString("assets/json/user.json");
    var dataJson = jsonDecode(data);

    return (dataJson['user'] as List).map((p) => User.fromJson(p)).toList();
  }

  Future<void> insertUserToDB(Database db, List<User> list) async {
    for (var customer in list) {
      await db.insert(
        'user',
        customer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
