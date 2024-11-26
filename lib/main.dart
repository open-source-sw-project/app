import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/screen/diagnosis.dart';
import 'firebase_options.dart';
import 'screen/log_in.dart';
import 'screen/sign_up.dart';
import 'screen/set_up_profile.dart';
import 'screen/home.dart';
import 'screen/loading_screen.dart';
import 'screen/profile.dart';
import 'screen/camera_screen.dart';

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
        '/diagnosis': (context) => const DiagnosisScreen(),
      },
    );
  }
}