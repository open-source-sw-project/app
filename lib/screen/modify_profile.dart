import 'package:flutter/material.dart';

class ModifyProfileScreen extends StatelessWidget {
  const ModifyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final String name = "Ruchita"; // 기존 저장된 이름
    final String phoneNumber = "01012345678"; // 기존 저장된 이름
    final String birthDate = "2001-01-01"; // 기존 저장된 생년월일

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
            Navigator.pushReplacementNamed(context, '/profile'); // 돌아가기
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // 기본 프로필 사진
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blueAccent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // 프로필 사진 수정 로직
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  '프로필 사진',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              // Name (Locked)
              TextField(
                readOnly: true, // 읽기 전용
                decoration: InputDecoration(
                  hintText: name, // 기존 이름 표시
                  filled: true, // 배경색 채우기
                  fillColor: Colors.grey[300], // 배경색 회색
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // 테두리 제거
                  ),
                  prefixIcon: const Icon(Icons.person_outline,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              // Phone Number (Editable)
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: phoneNumber, // 기존 이름 표시
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  prefixIcon: const Icon(Icons.phone_outlined,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 20),
              // Birth Date (Locked)
              TextField(
                readOnly: true, // 읽기 전용
                decoration: InputDecoration(
                  hintText: birthDate, // 기존 생년월일 표시
                  filled: true, // 배경색 채우기
                  fillColor: Colors.grey[300], // 배경색 회색
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // 테두리 제거
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      color: Colors.blueAccent),
                ),
              ),
              const SizedBox(height: 30),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 변경 사항 저장 로직 추가
                    Navigator.pushReplacementNamed(context, '/profile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}
