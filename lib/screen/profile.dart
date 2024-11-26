import 'package:flutter/material.dart';
import 'package:myapp/services/profile_service.dart'; // API 호출 파일 가져오기

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ruchita',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // My previous log 버튼
            ListTile(
              leading: const Icon(Icons.article, color: Colors.blueAccent),
              title: const Text('My previous log'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLogsDialog(context); // 팝업 표시
              },
            ),
            const Divider(),
            // Logout 버튼
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout'),
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
          title: const Text('Previous Logs'),
          content: SizedBox(
            height: 300,
            child: FutureBuilder<List<Log>>(
              future: ApiService.fetchLogs(), // API 호출
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // 로딩 표시
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'), // 에러 메시지
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No logs available'));
                } else {
                  // 데이터가 있을 경우 리스트 표시
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final log = snapshot.data![index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(log.imageUrl), // 이미지 표시
                        ),
                        title: Text(log.date), // 날짜 표시
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
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
                Navigator.pushNamed(context, '/logs'); // 전체 로그 페이지로 이동
              },
              child: const Text('See all logs'),
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
