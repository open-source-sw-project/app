import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 반원 그래프용 패키지
import '../api/firebase_api.dart'; // Firebase API import

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  bool _isLoading = true;

  final FirebaseApi _apiService = FirebaseApi();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await _apiService.getUserData();
      if (data != null) {
        setState(() {
          userName = '${data['Last Name']} ${data['First Name']}';
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // My previous log 버튼
            ListTile(
              leading:
              const Icon(Icons.article, color: Colors.blueAccent),
              title: const Text('최근 기록'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLogsDialog(context); // 팝업 표시
              },
            ),
            const Divider(),
            // 개인 정보 수정 버튼
            ListTile(
              leading: const Icon(Icons.person_outline,
                  color: Colors.blueAccent),
              title: const Text('내 정보 수정'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/modify_profile');
              },
            ),
            const Divider(),
            // Logout 버튼
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('로그아웃'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 로그 팝업 표시
  void _showLogsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('최근 기록'),
          content: SizedBox(
            height: 400,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _apiService.fetchDiagnoses(), // FirebaseApi의 fetchDiagnoses 호출
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // 로딩 표시
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'), // 에러 메시지
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No diagnoses available'));
                } else {
                  // 데이터가 있을 경우 리스트 표시
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final diagnosis = snapshot.data![index];
                      final String probabilityString =
                      diagnosis['melanoma_probability'];
                      final double probability = double.parse(
                          probabilityString.replaceAll('%', '').trim()); // 변환

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                          NetworkImage(diagnosis['imageUrl']), // 이미지 표시
                        ),
                        title: Text(
                          'Melanoma Probability: ${probability.toStringAsFixed(1)}%',
                        ),
                        onTap: () {
                          _showProbabilityGraph(context, probability);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // 확률 그래프 팝업
  void _showProbabilityGraph(BuildContext context, double probability) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Melanoma Probability'),
          content: SizedBox(
            height: 200,
            child: Center(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: probability,
                      color: Colors.red,
                      radius: 60,
                      title: '${probability.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 100 - probability,
                      color: Colors.grey,
                      radius: 60,
                      title: '',
                    ),
                  ],
                  startDegreeOffset: -90,
                  centerSpaceRadius: 0,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 로직
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
