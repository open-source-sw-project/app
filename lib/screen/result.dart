import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final Map<String, dynamic> analysisResult =
    arguments['analysisResult'] as Map<String, dynamic>;
    final String imageUrl = arguments['imageUrl'] as String;

    final String probabilityString = analysisResult["melanoma_probability"];
    final double melanomaProbability = double.parse(
        probabilityString.replaceAll('%', '').trim()); // 변환

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Diagnosis Result',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Image.network(imageUrl, height: 200),
                const SizedBox(height: 20),
                // 반원 차트 1: Melanoma Probability
                _buildSemiCircleChart(
                  title: 'Melanoma Probability',
                  value: melanomaProbability,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 20),
                // 반원 차트 2: Risk Level
                _buildSemiCircleChart(
                  title: 'Risk Level',
                  value: 70.0, // Example value
                  color: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                // 반원 차트 3: Assessment Confidence
                _buildSemiCircleChart(
                  title: 'Assessment Confidence',
                  value: 50.0, // Example value
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Notice:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (String notice in analysisResult["notice"])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '- $notice',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Back to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 반원 차트를 그리는 위젯
  Widget _buildSemiCircleChart(
      {required String title, required double value, required Color color}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: value,
                  color: color,
                  radius: 50,
                  title: '${value.toStringAsFixed(1)}%',
                  titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                PieChartSectionData(
                  value: 100 - value,
                  color: Colors.grey.shade300,
                  radius: 50,
                  title: '',
                ),
              ],
              startDegreeOffset: -90,
              centerSpaceRadius: 0,
              sectionsSpace: 0,
            ),
          ),
        ),
      ],
    );
  }
}
