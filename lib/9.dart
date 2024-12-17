import 'package:flutter/material.dart';

class RouteRegistrationPage extends StatelessWidget {
  final String startLocation;
  final String destinationLocation;
  final String departureTime;

  const RouteRegistrationPage({
    Key? key,
    required this.startLocation,
    required this.destinationLocation,
    required this.departureTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('노선 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '노선 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _infoCard('출발지', startLocation),
            const SizedBox(height: 12),
            _infoCard('도착지', destinationLocation),
            const SizedBox(height: 12),
            _infoCard('출발 시간', departureTime),
            const SizedBox(height: 24),
            // 등록 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 등록 완료 로직 구현 (예: 저장, DB 연동 등)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('노선이 등록되었습니다.')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('노선 등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 정보 카드 위젯
  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
