import 'package:flutter/material.dart';

class RideInputPage extends StatefulWidget {
  const RideInputPage({Key? key}) : super(key: key);

  @override
  State<RideInputPage> createState() => _RideInputPageState();
}

class _RideInputPageState extends State<RideInputPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isInputVisible = true;
  double _inputHeight = 250; // 기본 높이를 더 위로 설정
  final double _minHeight = 50; // 완전히 숨겨지지 않도록 최소 높이 설정
  final double _maxHeight = 200; // 최대 높이

  void toggleInputVisibility() {
    setState(() {
      _isInputVisible = !_isInputVisible;
      _inputHeight = _isInputVisible ? _maxHeight : _minHeight;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (details.velocity.pixelsPerSecond.dy > 0) {
        // 사용자가 아래로 드래그
        _isInputVisible = false;
        _inputHeight = _minHeight;
      } else {
        // 사용자가 위로 드래그
        _isInputVisible = true;
        _inputHeight = _maxHeight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // 지도 영역
          Positioned.fill(
            child: Container(
              color: Colors.blueAccent,
              child: const Center(
                child: Text(
                  '지도 영역 (여기에 지도 위젯 추가)',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          // 하단 입력 창
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onPanEnd: _onPanEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _inputHeight,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: toggleInputVisibility,
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (_isInputVisible) ...[
                      TextField(
                        controller: _startController,
                        decoration: const InputDecoration(
                          labelText: '출발지',
                          hintText: '출발지를 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _destinationController,
                        decoration: const InputDecoration(
                          labelText: '도착지',
                          hintText: '도착지를 입력하세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              _timeController.text = pickedTime.format(context);
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: '출발 시간',
                          hintText: '출발 시간을 선택하세요',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}