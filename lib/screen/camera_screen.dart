  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'dart:io';

  class CameraScreen extends StatefulWidget {
    const CameraScreen({super.key});

    @override
    State<CameraScreen> createState() => _CameraScreenState();
  }

  class _CameraScreenState extends State<CameraScreen> {
    final ImagePicker _picker = ImagePicker();

    @override
    void initState() {
      super.initState();
      _openCamera(); // 화면 진입 시 카메라 실행
    }

    Future<void> _openCamera() async {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        // 카메라로 찍은 사진을 DiagnosisScreen으로 전달
        Navigator.pushReplacementNamed(
          context,
          '/diagnosis',
          arguments: File(pickedFile.path),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // 카메라 실행 중 로딩 표시
        ),
      );
    }
  }
