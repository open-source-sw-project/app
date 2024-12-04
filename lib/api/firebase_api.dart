import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ------------------- 사용자 데이터 -------------------

  /// 현재 로그인된 사용자의 데이터를 가져옵니다.
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
        await _firestore.collection('users').doc(user.uid).get();
        if (docSnapshot.exists) {
          return docSnapshot.data(); // Firestore에서 사용자 데이터 반환
        }
      }
    } catch (e) {
      print('사용자 데이터 가져오기 오류: $e');
    }
    return null; // 사용자 데이터를 가져오지 못한 경우
  }

  /// 현재 로그인된 사용자의 데이터를 업데이트합니다.
  Future<void> updateUserData(Map<String, dynamic> data) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update(data);
      }
    } catch (e) {
      print('사용자 데이터 업데이트 오류: $e');
      throw Exception('Firestore 업데이트 실패');
    }
  }

  // ------------------- 인증 -------------------

  /// 이메일과 비밀번호로 사용자 로그인
  Future<User?> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // 로그인된 사용자 반환
    } catch (e) {
      print('로그인 오류: $e');
      throw Exception('로그인 실패');
    }
  }

  /// 사용자 로그아웃
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('로그아웃 오류: $e');
      throw Exception('로그아웃 실패');
    }
  }

  /// 비밀번호 재설정 이메일 보내기
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('비밀번호 재설정 이메일 전송 오류: $e');
      throw Exception('비밀번호 재설정 이메일 전송 실패');
    }
  }

  // Firestore 사용자 정보 업데이트 (예: 마지막 로그인 시간)
  Future<void> updateLastLogin(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating last login: $e');
    }
  }

  //-------------------- diagnosis 관련 -----------------

  // diagnoses 컬렉션에서 데이터 가져오기
  Future<List<Map<String, dynamic>>> fetchDiagnoses() async {
    try {
      final querySnapshot = await _firestore.collection('diagnoses').get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Failed to fetch diagnoses: $e');
    }
  }

  // ------------------- Firestore 유틸리티 -------------------

  /// Firestore에 새 사용자 데이터 추가
  Future<void> createUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).set(data);
    } catch (e) {
      print('사용자 데이터 생성 오류: $e');
      throw Exception('Firestore 데이터 생성 실패');
    }
  }

  /// Firestore 문서 삭제
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('사용자 데이터 삭제 오류: $e');
      throw Exception('Firestore 데이터 삭제 실패');
    }
  }
}
