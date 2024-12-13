import 'package:flutter/material.dart';
import '1.dart'; // 1.dart 파일 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moata 서비스 약관 동의',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TermsAgreementScreen(), // 1.dart의 TermsAgreementScreen을 초기 화면으로 설정
    );
  }
}
