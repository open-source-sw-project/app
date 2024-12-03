import 'package:flutter/material.dart';

class CheckNameNumber extends StatefulWidget {
  const CheckNameNumber({super.key});

  @override
  State<CheckNameNumber> createState() => _CheckNameNumberState();
}

class _CheckNameNumberState extends State<CheckNameNumber> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? errorText;

  // 이름과 전화번호 검증 함수
  bool isDetailsValid(String name, String phone) {
    return name == "John Doe" && phone == "1234567890"; // 가짜 데이터
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'HanDoc.',
                        style: TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '사용자 인증',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '이름과 전화번호를 입력하세요\n',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        prefixIcon: const Icon(Icons.person_outline,
                            color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blueAccent),
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: Colors.blueAccent),
                      ),
                    ),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Reset Password
                    Navigator.pushNamed(context, '/resetPassword');
                    /*
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    if (isDetailsValid(name, phone)) {
                      Navigator.pushNamed(context, '/resetPassword');
                    } else {
                      setState(() {
                        errorText = "이름이나 전화번호가 올바르지 않습니다.";
                      });
                    }

                     */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // 하단 여백
          ],
        ),
      ),
    );
  }
}
