import 'package:flutter/material.dart';
import '../api/firebase_api.dart'; // Firebase API Import

class ModifyProfileScreen extends StatefulWidget {
  const ModifyProfileScreen({super.key});

  @override
  State<ModifyProfileScreen> createState() => _ModifyProfileScreenState();
}

class _ModifyProfileScreenState extends State<ModifyProfileScreen> {
  final TextEditingController phoneController = TextEditingController();
  String name = '';
  String phoneNumber = '';
  String birthDate = '';
  bool _isLoading = true;
  bool _isSaving = false; // 저장 중 상태 추가

  final FirebaseApi _apiService = FirebaseApi();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // 사용자 데이터 가져오기
  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _apiService.getUserData();
      if (data != null) {
        setState(() {
          name = '${data['First Name']} ${data['Last Name']}';
          phoneNumber = data['Mobile'] ?? '';
          birthDate = data['Birth'] ?? '';
          phoneController.text = phoneNumber; // 초기 값 설정
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 데이터를 가져오는 중 오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 사용자 데이터 업데이트
  Future<void> _updateUserData() async {
    setState(() {
      _isSaving = true;
    });
    try {
      final newPhone = phoneController.text.trim();
      if (newPhone.isEmpty) {
        throw Exception('전화번호를 입력하세요.');
      }

      await _apiService.updateUserData({'Mobile': newPhone});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 성공적으로 업데이트되었습니다.')),
      );
      Navigator.pushReplacementNamed(context, '/profile'); // 프로필 화면으로 이동
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 업데이트 중 오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          '내 정보 수정',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile'); // 뒤로 가기
          },
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // 로딩 상태 표시
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // 이름 (수정 불가)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: name,
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              // 전화번호 (수정 가능)
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '전화번호',
                  hintText: '전화번호를 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              // 생년월일 (수정 불가)
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: '생년월일',
                  hintText: birthDate,
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 30),
              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _updateUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    '저장',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
