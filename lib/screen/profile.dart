import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // 프로필 사진 및 이름
            Center(
              child: Column(
                children: [
                  // 프로필 이미지
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // 기본 프로필 이미지 URL
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ruchita', // 사용자 이름
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // 옵션 리스트
            Expanded(
              child: ListView(
                children: [
                  // My Previous Log 버튼
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: Colors.blueAccent,
                    ),
                    title: const Text('My previous log'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // 로그 화면으로 이동하는 로직
                      Navigator.pushNamed(context, '/logs');
                    },
                  ),
                  const Divider(),
                  // 로그아웃 버튼
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: const Text('Logout'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      _showLogoutDialog(context); // 로그아웃 확인 다이얼로그
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 다른 기능 추가 가능 (예: 프로필 사진 변경)
        },
        backgroundColor: Colors.white,
        child: const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://via.placeholder.com/100', // 서브 이미지
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Profile 탭 활성화
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home'); // Home으로 이동
          } else if (index == 1) {
            Navigator.pushNamed(context, '/diagnosis'); // Diagnosis로 이동
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
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

  // 로그아웃 확인 다이얼로그
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login', // 로그아웃 후 로그인 화면으로 이동
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
