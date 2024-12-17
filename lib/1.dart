import 'package:flutter/material.dart';
import '2.dart'; // lib 디렉토리 내에 있는 2.dart 파일을 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TermsAgreementScreen(),
    );
  }
}

class TermsAgreementScreen extends StatefulWidget {
  @override
  _TermsAgreementScreenState createState() => _TermsAgreementScreenState();
}

class _TermsAgreementScreenState extends State<TermsAgreementScreen> {
  bool allChecked = false;
  bool is14Above = false;
  bool termsChecked = false;
  bool locationChecked = false;
  bool personalInfoChecked = false;
  bool marketingChecked = false;

  void toggleAll(bool value) {
    setState(() {
      allChecked = value;
      is14Above = value;
      termsChecked = value;
      locationChecked = value;
      personalInfoChecked = value;
      marketingChecked = value;
    });
  }

  void checkAllMandatoryChecked() {
    setState(() {
      allChecked = is14Above && termsChecked && locationChecked && personalInfoChecked && marketingChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0, // Hide the AppBar
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              '원활한 MOATA 사용을 위한\n서비스 약관에 동의해 주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: allChecked,
                  onChanged: (value) {
                    toggleAll(value!);
                  },
                ),
                Expanded(
                  child: Text(
                    '모두 동의합니다.',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                '전체 동의는 필수 및 선택 정보에 대한 동의가 포함되어 있으며, 개별적으로 동의가 가능합니다.',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
            Divider(color: Colors.black),
            Expanded(
              child: ListView(
                children: [
                  buildCheckboxRow(
                    '[필수] 만 14세 이상입니다.',
                    is14Above,
                    (value) {
                      setState(() {
                        is14Above = value!;
                        checkAllMandatoryChecked();
                      });
                    },
                  ),
                  buildCheckboxRow(
                    '[필수] 서비스 이용약관 동의',
                    termsChecked,
                    (value) {
                      setState(() {
                        termsChecked = value!;
                        checkAllMandatoryChecked();
                      });
                    },
                    hasArrow: true,
                  ),
                  buildCheckboxRow(
                    '[필수] 위치정보 수집 및 이용 동의',
                    locationChecked,
                    (value) {
                      setState(() {
                        locationChecked = value!;
                        checkAllMandatoryChecked();
                      });
                    },
                    hasArrow: true,
                  ),
                  buildCheckboxRow(
                    '[필수] 개인정보 수집 및 이용 동의',
                    personalInfoChecked,
                    (value) {
                      setState(() {
                        personalInfoChecked = value!;
                        checkAllMandatoryChecked();
                      });
                    },
                    hasArrow: true,
                  ),
                  buildCheckboxRow(
                    '[선택] 마케팅 수신 동의',
                    marketingChecked,
                    (value) {
                      setState(() {
                        marketingChecked = value!;
                        checkAllMandatoryChecked();
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      '모아타에서 제공하는 이벤트 및 소식 등을 SMS, 이메일, 앱 내 알림 등으로 받겠습니다.',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (is14Above && termsChecked && locationChecked && personalInfoChecked)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PermissionScreen()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 배경 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16), // 버튼 내부 여백
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxRow(String text, bool value, Function(bool?) onChanged, {bool hasArrow = false}) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        if (hasArrow)
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 16,
          ),
      ],
    );
  }
}
