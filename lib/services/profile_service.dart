import 'dart:convert'; // JSON 처리
import 'package:http/http.dart' as http; // HTTP 요청

// 로그 데이터를 나타내는 클래스
class Log {
  final String date;
  final String imageUrl;

  Log({required this.date, required this.imageUrl});

  // JSON 데이터를 Log 객체로 변환
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      date: json['date'] ?? 'Unknown date',
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150', // 기본 이미지
    );
  }
}

// API 서비스 클래스
class ApiService {
  static const String baseUrl = 'https://example.com/api'; // API 기본 URL

  // 로그 데이터를 가져오는 함수
  static Future<List<Log>> fetchLogs() async {
    final response =
        await http.get(Uri.parse('$baseUrl/logs')); // logs 엔드포인트 호출
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((log) => Log.fromJson(log)).toList();
    } else {
      throw Exception('Failed to load logs');
    }
  }
}
