import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/log_in.dart';
import 'screen/sign_up.dart';
import 'screen/set_up_profile.dart';
import 'screen/home.dart';
import 'screen/loading_screen.dart';
import 'screen/profile.dart';
import 'screen/camera_screen.dart';
import 'screen/forgot_password.dart';
import 'screen/check_name_number.dart';
import 'screen/diagnosis.dart';
import 'screen/modify_profile.dart';
import 'screen/result.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LogInScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/setUpProfile': (context) => const SetUpProfileScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/camera': (context) => const CameraScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/diagnosis': (context) => const DiagnosisScreen(),
        '/modify_profile': (context) => const ModifyProfileScreen(),
        '/result': (context) => const ResultScreen(),
      },
      onGenerateRoute: (settings) {
        // 이메일 전달을 위해 onGenerateRoute 사용
        if (settings.name == '/checkIdentity') {
          final email = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => CheckNameNumber(email: email),
          );
        }
        return null; // 다른 경로는 기본 routes로 처리
      },
    );
  }
}
