import 'package:flutter/material.dart';

class RouteRegistrationPage extends StatefulWidget {
  final String startLocation; // \u출발지
  final String destinationLocation; // 도착지
  final String departureTime; // 출발 시간
  final String? durationInSeconds; //estimatedTime; // 예상 소요 시간
  final String? taxiFare; //estimatedCost; // 예상 금액

  const RouteRegistrationPage({
    Key? key,
    required this.startLocation,
    required this.destinationLocation,
    required this.departureTime,
    this.durationInSeconds,
    this.taxiFare//estimatedCost,
  }) : super(key: key);

  @override
  State<RouteRegistrationPage> createState() => _RouteRegistrationPageState();
}

class _RouteRegistrationPageState extends State<RouteRegistrationPage> {
  String _selectedOption = '동성끼리'; // 기본 선택값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('출발지', widget.startLocation),
            const SizedBox(height: 12),
            _buildInfoCard('도착지', widget.destinationLocation),
            const SizedBox(height: 12),
            _buildInfoCard('출발 시간', widget.departureTime),
            const SizedBox(height: 12),
            _buildInfoCard('예상 소요 시간', widget.durationInSeconds ?? '0'),
            const SizedBox(height: 12),
            _buildInfoCard('예상 금액', widget.taxiFare ?? '0' ),
            const SizedBox(height: 24),
            const Text(
              '기타',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioOption('동성끼리'),
                const SizedBox(width: 16),
                _buildRadioOption('성별무관'),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 이전 페이지로 돌아감
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('노선생성', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    return Row(
      children: [
        Radio<String>(
          value: title,
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = value!;
            });
          },
          activeColor: Colors.blue,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}