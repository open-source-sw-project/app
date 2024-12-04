import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email; // 이전 화면에서 전달된 이메일

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? errorText;
  bool _isLoading = false;

  Future<void> resetPassword(String newPassword) async {
    setState(() {
      _isLoading = true;
      errorText = null; // 초기화
    });

    try {
      // Firestore에서 이메일 기반으로 사용자 문서 조회
      final querySnapshot = await _firestore
          .collection('User')
          .where('email', isEqualTo: widget.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final currentUser = _auth.currentUser;

        if (currentUser != null) {
          // 인증된 사용자로 비밀번호 변경
          await currentUser.updatePassword(newPassword);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
          );

          // 로그인 화면으로 이동
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        } else {
          // 이메일 기반으로 비밀번호 재설정 링크 전송
          await _auth.sendPasswordResetEmail(email: widget.email);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('비밀번호 재설정 이메일이 전송되었습니다.')),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } else {
        setState(() {
          errorText = '등록된 사용자를 찾을 수 없습니다.';
        });
      }
    } catch (e) {
      setState(() {
        errorText = '오류가 발생했습니다: ${e.toString()}';
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '비밀번호 변경',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '새 비밀번호를 입력하세요\n',
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
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        errorText: errorText,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                final newPassword = passwordController.text.trim();
                if (newPassword.isNotEmpty) {
                  resetPassword(newPassword);
                } else {
                  setState(() {
                    errorText = '새 비밀번호를 입력하세요.';
                  });
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('변경'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
