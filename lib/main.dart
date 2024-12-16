import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart'; // 네이버 지도 패키지 import
import '1.dart'; // 1.dart 파일 import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 네이버 지도 SDK 초기화
  await NaverMapSdk.instance.initialize(
    clientId: 'v2dyhbtaq4', // 네이버 클라우드 플랫폼에서 발급받은 Client ID
    onAuthFailed: (ex) {
      print("네이버 지도 인증 실패: $ex");
    },
  );
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

