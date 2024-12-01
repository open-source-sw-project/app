import 'package:flutter/material.dart';
import 'dart:io';

class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final File? image = ModalRoute.of(context)!.settings.arguments as File?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: image != null
                  ? Image.file(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Submit 버튼 눌렀을 때 로직 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/camera'); // 다시 카메라 실행
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'RETAKE',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
