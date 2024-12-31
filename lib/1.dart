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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[800]),
        ),
      ),
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
      allChecked = is14Above && termsChecked && locationChecked && personalInfoChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0, // AppBar 숨김
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                '원활한 MOATA 사용을 위한\n서비스 약관에 동의해 주세요',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'MOATA를 원활히 사용하려면 아래 약관에 동의해주세요.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: allChecked,
                          onChanged: (value) {
                            toggleAll(value!);
                          },
                          activeColor: Colors.lightBlue,
                        ),
                        Expanded(
                          child: Text(
                            '모두 동의합니다.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
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
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
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
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      '다음으로',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckboxRow(String text, bool value, Function(bool?) onChanged, {bool hasArrow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.lightBlue,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
          if (hasArrow)
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
        ],
      ),
    );
  }
}


