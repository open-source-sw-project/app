import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 샘플 데이터
    final File? image = null; // 이미지 없음
    final double sampleProbability = 0.45; // 45% 예측 확률(임시)
    final bool isMelanoma = false; // 흑색종 여부 (샘플 데이터)

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text('진단 결과'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 이미지 영역
            Expanded(
              child: image != null
                  ? Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  : const Center(
                child: Text(
                  '이미지를 불러올 수 없습니다.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 결과 메시지
            Text(
              isMelanoma
                  ? '흑색종일 가능성이 높습니다!'
                  : '흑색종이 아닙니다!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isMelanoma ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            // 예측 확률
            Text(
              '확률: ${(sampleProbability * 100).toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // 추가 설명
            const Text(
              '진단 결과를 참고하시고, 정확한 확인을 위해 의사의 상담을 권장합니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}