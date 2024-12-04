import 'dart:io';
import 'dart:convert';
import '../api/api.dart'; // api.dart 파일 경로

class MelanomaService {
  static Future<Map<String, dynamic>> analyzeMelanoma(File imageFile) async {
    try {
      var response = await Api.uploadFile('predict', 'image', imageFile);
      if (response.statusCode == 200) {
        return json.decode(response.body)['report'];
      } else {
        throw Exception('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('분석 중 오류 발생: $e');
    }
  }
}
