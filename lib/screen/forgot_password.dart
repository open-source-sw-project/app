import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String? emailError;
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> checkEmailInDatabase(String email) async {
    setState(() {
      _isLoading = true;
      emailError = null; // 오류 초기화
    });

    try {
      // Firestore에서 이메일 검색
      final querySnapshot = await _firestore
          .collection('users') // Firestore의 users 컬렉션
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 이메일이 존재하면 CheckNameNumber 화면으로 이동하며 이메일 전달
        if (!mounted) return;
        Navigator.pushNamed(context, '/checkIdentity', arguments: email);
      } else {
        // 이메일이 존재하지 않을 경우 에러 메시지 표시
        setState(() {
          emailError = '등록되지 않은 이메일입니다.';
        });
      }
    } catch (e) {
      setState(() {
        emailError = '오류가 발생했습니다. 다시 시도해주세요.';
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
        child: Stack(
          children: [
            if (_isLoading) ...[
              const Center(
                child: CircularProgressIndicator(), // 전체 화면 로딩 인디케이터
              )
            ],
            if (!_isLoading) ...[
              Column(
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
                                '계정 찾기',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '아이디로 사용한 이메일을 입력하세요\n',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email ID',
                              errorText: emailError, // Firestore 결과에 따라 에러 메시지 표시
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: Colors.blueAccent),
                              ),
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.blueAccent),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          final email = emailController.text.trim();
                          if (email.isEmpty) {
                            setState(() {
                              emailError = '이메일을 입력하세요.';
                            });
                          } else if (!isValidEmail(email)) {
                            setState(() {
                              emailError = '유효하지 않은 이메일 형식입니다.';
                            });
                          } else {
                            checkEmailInDatabase(email); // Firestore 확인 함수 호출
                          }
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
                  const SizedBox(height: 20),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
