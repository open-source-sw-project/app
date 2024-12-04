import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../services/melanoma_service.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  bool _isLoading = false;

  Future<void> _submitDiagnosis(File imageFile) async {
    setState(() => _isLoading = true);

    try {
      // Flask 서버에 이미지 전송 및 분석 결과 가져오기
      final analysisResult = await MelanomaService.analyzeMelanoma(imageFile);

      // Firebase Storage에 이미지 업로드
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('diagnoses')
          .child(user.uid)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();

      // 분석 결과를 `ResultScreen`으로 전달
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: {
          'analysisResult': analysisResult,
          'imageUrl': imageUrl,
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
                  onPressed: _isLoading
                      ? null
                      : () => image != null
                      ? _submitDiagnosis(image)
                      : null,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SUBMIT'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.pushReplacementNamed(context, '/camera');
                  },
                  child: const Text('RETAKE'),
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
