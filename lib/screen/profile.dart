import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 반원 그래프용 패키지
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // 날짜 형식 변경
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
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  List<Map<String, dynamic>> _diagnoses = []; // 선택된 날짜의 진단 데이터를 저장
  DateTime? _selectedDate; // 선택된 날짜
  int _currentIndex = 2; // Profile 탭 기본 활성화

  void _onTabTapped(int index) {
    if (index == 0) {
      // Home 화면으로 이동
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      // Diagnosis 화면으로 이동
      Navigator.pushNamed(context, '/camera');
    } else if (index == 2) {
      // Profile 화면 현재 유지
      setState(() {
        _currentIndex = index;
      });
    }
  }

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

  Future<List<DateTime>> _fetchAvailableDates() async {
    try {
      final dates = await _apiService.fetchAvailableDates(uid);
      dates.sort(); // 날짜 정렬
      return dates;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching dates: $e')),
      );
      return [];
    }
  }

  Future<void> _selectDateFromAvailable(BuildContext context) async {
    final availableDates = await _fetchAvailableDates();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Diagnosis Date'),
          content: SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: availableDates.length,
              itemBuilder: (context, index) {
                final date = availableDates[index];
                return ListTile(
                  title: Text(DateFormat('yyyy-MM-dd').format(date)),
                  onTap: () {
                    Navigator.pop(context, date); // 선택한 날짜 반환
                  },
                );
              },
            ),
          ),
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
        _fetchDiagnosesForSelectedDate();
      }
    });
  }

  Future<void> _fetchDiagnosesForSelectedDate() async {
    if (_selectedDate == null) return;
    try {
      final data = await _apiService.fetchDiagnosesForDate(uid, _selectedDate!);
      setState(() {
        _diagnoses = data;
      });
      _showLogsDialog(context); // 데이터를 가져온 후 팝업 표시
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching diagnoses: $e')),
      );
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
              leading: const Icon(Icons.article,
                  color: Colors.blueAccent),
              title: const Text('과거 기록'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _selectDateFromAvailable(context); // 날짜 선택 창 열기
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
              leading:
              const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('로그아웃'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _logout(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Diagnosis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // 로그 팝업 표시
  void _showLogsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Records for ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
          content: SizedBox(
            height: 400,
            child: _diagnoses.isEmpty
                ? const Center(child: Text('No diagnoses available'))
                : ListView.builder(
              itemCount: _diagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = _diagnoses[index];
                final String probabilityString =
                diagnosis['melanoma_probability'];
                final double probability = double.parse(
                    probabilityString.replaceAll('%', '').trim());
                final imageUrl = diagnosis['imageUrl'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(
                    'Melanoma Probability: ${probability.toStringAsFixed(1)}%',
                  ),
                  onTap: () {
                    _showProbabilityGraph(context, probability);
                  },
                );
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
