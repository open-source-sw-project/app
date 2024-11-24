import 'package:flutter/material.dart';
import 'log_in.dart'; // log_in.dart를 import합니다.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LogInScreen(),
    );
  }
}
