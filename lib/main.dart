import 'package:daily_planner/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/sqlite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper().LoadUser();
  await DatabaseHelper().LoadTask();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeWidget(),
      supportedLocales: [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('vi', 'VN'),
    );
  }
}
