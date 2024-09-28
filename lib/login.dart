import 'dart:convert';

import 'package:daily_planner/config/const.dart';
import 'package:daily_planner/page/mainpage.dart';
import 'package:flutter/material.dart';

import 'data/sqlite.dart';
import 'model/user.dart';
import 'page/task/tasklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DatabaseHelper _databaseHelper = DatabaseHelper();

    Future<bool> saveUser(User user) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String strUser = jsonEncode(user);
        prefs.setString('user', strUser);
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }

    Future<List<User>> _getUsers() async {
      return await _databaseHelper.getAllUser();
    }

    void _login() async {
      await saveUser(User(id: -1));
      List<User> users = await _getUsers();

      User? user = users.isNotEmpty
          ? users.firstWhere(
              (u) =>
                  u.email == _emailController.text &&
                  u.password == _passwordController.text,
              orElse: () => User(id: -1))
          : User(id: -1);

      if (user.id != -1) {
        if (await saveUser(user) == true) {
          print(user.name);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainWidget()),
        );
      } else {
        print("Sai mật khẩu hoặc tài khoản");
      }
    }

    return Scaffold(
      backgroundColor: light,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Đăng nhập",
                style: title,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 16),
                obscureText: false,
                decoration: InputDecoration(
                  labelText: "Email...",
                  prefixIcon: const Icon(
                    Icons.email,
                    color: branchColor2,
                  ),
                  iconColor: branchColor,
                  labelStyle: const TextStyle(
                    color: branchColor,
                    fontSize: 16,
                  ),
                  border: myOutlineInputBorder3(),
                  focusedBorder: myOutlineInputBorder3(),
                  enabledBorder: myOutlineInputBorder1(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }

                  return null;
                },
                onChanged: null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                style: const TextStyle(fontSize: 16),
                obscureText: true, // Để ẩn ký tự mật khẩu
                decoration: InputDecoration(
                  labelText: "Mật khẩu...",
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: branchColor2,
                  ),
                  iconColor: branchColor,
                  labelStyle: const TextStyle(
                    color: branchColor,
                    fontSize: 16,
                  ),
                  border: myOutlineInputBorder3(),
                  focusedBorder: myOutlineInputBorder3(),
                  enabledBorder: myOutlineInputBorder1(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
                onChanged: null,
              ),
              const SizedBox(
                height: 50,
              ),
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
                  onPressed: () {
                    _login();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const MainWidget(),
                    //   ),
                    // );
                  },
                  child: const Text(
                    "Đăng nhập",
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
