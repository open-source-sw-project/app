import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiagnosisScreen extends StatefulWidget {
  final File? image; // 이전 화면에서 찍은 이미지를 전달받음
  const DiagnosisScreen({Key? key, this.image}) : super(key: key);

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  late File? _image = widget.image; // 전달받은 이미지를 초기화

  // 서버로 이미지 업로드
Future<void> _submitImage() async {
  if (_image == null) {
    throw Exception('No image selected');
  }

  try {
    // 서버에 이미지 업로드 요청 (예: http 패키지 사용)
    // var request = http.MultipartRequest('POST', Uri.parse('YOUR_API_URL'));
    // request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    // var response = await request.send();

    // 임시로 2초 딜레이를 추가해 서버 처리 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));
  } catch (e) {
    throw Exception('Image upload failed: $e');
  }
}

  // 사진 다시 찍기
  Future<void> _retakePhoto() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 새로 찍은 사진으로 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 찍은 사진 미리보기
            Expanded(
              child: Center(
                child: _image == null
                    ? const Text(
                        'No image available',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      )
                    : Image.file(_image!), // 선택된 이미지 표시
              ),
            ),
            const SizedBox(height: 20),
            // Submit 및 Retake 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
ElevatedButton(
  onPressed: () async {
    // 로딩 화면으로 이동
    Navigator.pushNamed(context, '/loading');

    try {
      // 서버로 이미지 업로드 로직
      await _submitImage(); // 이미지 업로드 함수 실행

      // 성공 시 결과 화면으로 이동
      Navigator.pushReplacementNamed(context, '/result');
    } catch (e) {
      // 에러 발생 시 로딩 화면 종료 후 메시지 표시
      Navigator.pop(context); // 로딩 화면 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit image: $e'),
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
  ),
  child: const Text(
    'SUBMIT',
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
),
                ElevatedButton(
                  onPressed: _retakePhoto, // Retake 버튼 눌렀을 때 실행
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Diagnosis 탭 활성화
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Home으로 이동
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile'); // Profile으로 이동
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Diagnosis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
