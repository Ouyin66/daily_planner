import 'package:daily_planner/config/const.dart';
import 'package:daily_planner/page/mainpage.dart';
import 'package:flutter/material.dart';

import 'page/task/tasklist.dart';

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
    return Scaffold(
      backgroundColor: light,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 10),
        child: Column(
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
              height: 30,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainWidget(),
                    ),
                  );
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
    );
  }
}
