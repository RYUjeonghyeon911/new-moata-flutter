import 'package:flutter/material.dart';
import '5.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VerificationScreen(),
    );
  }
}

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); //이전화면으로 이동
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40), // 상단 여백 추가
            Text(
              '시작해볼까요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '안전한 탑승을 위해 최초 1회\n본인인증 절차가 필요합니다.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              '전화번호는 안전하게 보관되며 공개되지 않아요.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60), // 버튼 위의 여백을 조정
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NameInputScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16), // 상하 패딩 설정
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white, // 버튼 텍스트 색상
                      fontSize: 16, // 글자 크기
                      fontWeight: FontWeight.bold, // 글자 굵기
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40), // 하단 여백 추가
          ],
        ),
      ),
    );
  }
}
