import 'package:flutter/material.dart';
import 'screen/log_in.dart';
import 'screen/sign_up.dart';
import 'screen/set_up_profile.dart';
import 'screen/home.dart';
import 'screen/loading_screen.dart';
import 'screen/past_logs.dart';
import 'screen/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // 기본 화면: 로그인 화면
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LogInScreen(), // 로그인 화면
        '/signUp': (context) => const SignUpScreen(), // 회원가입 첫 번째 화면
        '/setUpProfile': (context) =>
            const SetUpProfileScreen(), // 회원가입 두 번째 화면
        '/loading': (context) => const LoadingScreen(),
//        '/logs' : (context) => const LogScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
