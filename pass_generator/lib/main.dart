import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pass_generator/login.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) => FTheme(
                data: FThemes.zinc.light,
                child: child!,
              ),
          home: const Login()),
    );
  }
}
