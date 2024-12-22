import 'package:flutter/material.dart';
import '8.dart'; // 8.dart 파일을 정확히 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SuccessInputScreen(),
    );
  }
}

class SuccessInputScreen extends StatefulWidget {
  @override
  _SuccessInputScreen createState() => _SuccessInputScreen();
}

class _SuccessInputScreen extends State<SuccessInputScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = true;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        // _isButtonEnabled = _controller.text.length >= 2;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                '본인확인이 완료되었습니다.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Text(
                '이제 모아타와 함께 떠나볼까요?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              MouseRegion(
                onEnter: (event) => _changeHoverState(true),
                onExit: (event) => _changeHoverState(false),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RideInputPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isHovered
                        ? Colors.blue // 마우스 호버 시
                        : (_isButtonEnabled
                            ? Colors.blue // 버튼 활성화 시
                            : Colors.blueGrey[100]), // 버튼 비활성화 시
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 18,
                      color: _isHovered || _isButtonEnabled
                          ? Colors.white
                          : Colors.grey,
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

  void _changeHoverState(bool hover) {
    setState(() {
      _isHovered = hover;
    });
  }
}
