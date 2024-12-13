import 'package:flutter/material.dart';
import '8.dart';
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
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.length >= 2;
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
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
              onEnter: (event) => _changeButtonColor(true),
              onExit: (event) => _changeButtonColor(false),
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    RideInputPage()),
                  );
                        // "다음" 버튼 동작
                        print('이름: ${_controller.text}');
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? Colors.blue // 활성화된 상태
                      : Colors.blueGrey[100], // 비활성화된 상태
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 18,
                    color: _isButtonEnabled ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeButtonColor(bool hover) {
    setState(() {
      _isButtonEnabled = hover || _controller.text.length >= 2;
    });
  }
}