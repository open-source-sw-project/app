import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Api {
  static const String baseUrl = 'http://192.168.149.186:5000/'; // 서버 URL
  // Firebase 연결 등 추가 설정이 여기 포함될 수 있음.

  static Future<http.Response> post(String endpoint, dynamic body) async {
    try {
      final Uri url = Uri.parse('$baseUrl$endpoint');
      return await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('POST 요청 중 오류 발생: $e');
    }
  }

  static Future<http.Response> get(String endpoint) async {
    try {
      final Uri url = Uri.parse('$baseUrl$endpoint');
      return await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw Exception('GET 요청 중 오류 발생: $e');
    }
  }

  static Future<http.Response> uploadFile(String endpoint, String fieldName, File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile(
        fieldName,
        stream,
        length,
        filename: file.path.split('/').last,
      );

      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      throw Exception('파일 업로드 중 오류 발생: $e');
    }
  }
}
