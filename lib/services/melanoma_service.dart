// lib/services/melanoma_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MelanomaService {
  static const String baseUrl = 'http://192.168.0.9:5000/'; // Flask 서버 URL로 변경

  static Future<Map<String, dynamic>> analyzeMelanoma(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict'));
      
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: imageFile.path.split('/').last
      );
      
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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