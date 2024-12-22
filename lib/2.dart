import 'package:flutter/material.dart';
import '3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PermissionScreen(),
    );
  }
}

class PermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 이동
          },
        ),
      ),
      backgroundColor: Colors.grey[100], // 배경색 설정
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '원활한 MOATA 사용을 위한\n접근 권한 안내입니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildPermissionItem(
              icon: Icons.location_on,
              title: '위치',
              description: '출발지 및 도착지 설정에 사용됩니다.',
              iconColor: Colors.red,
            ),
            _buildDivider(),
            _buildPermissionItem(
              icon: Icons.phone,
              title: '전화',
              description: '원활한 연락을 수신·발신하기 위해 필요합니다.',
              iconColor: Colors.green,
            ),
            _buildDivider(),
            _buildPermissionItem(
              icon: Icons.folder,
              title: '미디어 파일',
              description: '프로필 관리를 위해 필요합니다.',
              iconColor: Colors.orange,
            ),
            _buildDivider(),
            _buildPermissionItem(
              icon: Icons.camera_alt,
              title: '카메라',
              description: '결제 카드 스캔 및 프로필 관리를 위해 필요합니다.',
              iconColor: Colors.purple,
            ),
            SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 다음 화면으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }
}


