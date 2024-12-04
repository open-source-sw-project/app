import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckNameNumber extends StatefulWidget {
  final String email; // 이전 화면에서 전달받은 이메일

  const CheckNameNumber({super.key, required this.email});

  @override
  State<CheckNameNumber> createState() => _CheckNameNumberState();
}

class _CheckNameNumberState extends State<CheckNameNumber> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String? errorText;
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore에서 이름과 전화번호 확인
  Future<void> checkDetails(String name, String phone) async {
    setState(() {
      _isLoading = true;
      errorText = null; // 초기화
    });

    try {
      // Firestore에서 이메일로 사용자 문서 조회
      final querySnapshot = await _firestore
          .collection('users') // Firestore의 users 컬렉션
          .where('email', isEqualTo: widget.email) // 이메일 필드와 비교
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();

        // 이름과 전화번호 확인 (대소문자 구분 없이 처리)
        final fullName = '${userData['lastName']}${userData['firstName']}';
        if (fullName.toLowerCase().trim() == name.toLowerCase().trim() &&
            userData['mobile'] == phone.trim()) {
          // 일치할 경우 비밀번호 재설정 이메일 전송
          await _auth.sendPasswordResetEmail(email: widget.email);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('비밀번호 재설정 이메일이 전송되었습니다.'),
            ),
          );

          // 로그인 화면으로 이동
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          // 이름 또는 전화번호가 일치하지 않을 경우
          setState(() {
            errorText = '이름이나 전화번호가 올바르지 않습니다.';
          });
        }
      } else {
        // 이메일에 해당하는 사용자가 없을 경우
        setState(() {
          errorText = '사용자를 찾을 수 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        errorText = '오류가 발생했습니다. 다시 시도해주세요.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined,
                            color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (errorText != null)
                      Text(
                        errorText!,
                        style: const TextStyle(color: Colors.red),
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
                  onPressed: _isLoading
                      ? null
                      : () {
                    final name = nameController.text.trim();
                    final phone = phoneController.text.trim();
                    if (name.isNotEmpty && phone.isNotEmpty) {
                      checkDetails(name, phone);
                    } else {
                      setState(() {
                        errorText = '모든 필드를 입력하세요.';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
