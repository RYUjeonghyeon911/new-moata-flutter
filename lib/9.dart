import 'package:flutter/material.dart';
import '10.dart'; // 10.dart를 import

class RouteRegistrationPage extends StatefulWidget {
  final String startLocation; // 출발지
  final String destinationLocation; // 도착지
  final String departureTime; // 출발 시간
  final String? durationInSeconds; // 예상 소요 시간
  final String? totalFare; // 예상 금액

  const RouteRegistrationPage({
    Key? key,
    required this.startLocation,
    required this.destinationLocation,
    required this.departureTime,
    this.durationInSeconds,
    this.totalFare,
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
        title: const Text(
          '노선 정보',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 상단 설명 텍스트
              Column(
                children: [
                  const Text(
                    '출발지 및 도착지를 확인하세요',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '예상 소요 시간 및 금액이 표시됩니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 출발지 및 도착지 카드
              _buildInfoCard('출발지', widget.startLocation, Icons.location_on_outlined),
              const SizedBox(height: 12),
              _buildInfoCard('도착지', widget.destinationLocation, Icons.flag_outlined),
              const SizedBox(height: 12),
              _buildInfoCard('출발 시간', widget.departureTime, Icons.access_time_outlined),
              const SizedBox(height: 12),
              _buildInfoCard(
                '예상 소요 시간',
                _formatDuration(widget.durationInSeconds ?? '0'),
                Icons.schedule_outlined,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                '예상 금액',
                _formatCurrency(widget.totalFare ?? '0'),
                Icons.monetization_on_outlined,
              ),
              const SizedBox(height: 30),
              // 기타 옵션
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '기타 옵션',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // 다음 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 10.dart로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CostSharingPage(
                          totalFare: widget.totalFare ?? '0', // 총 비용 전달
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  /// **소요 시간을 분 단위로 포맷팅**
  String _formatDuration(String durationInSeconds) {
    int seconds = int.tryParse(durationInSeconds) ?? 0;
    int minutes = (seconds / 60000).floor();
    return '${minutes}분';
  }

  /// **금액을 천 단위 콤마로 포맷**
  String _formatCurrency(String totalFare) {
    int amount = int.tryParse(totalFare) ?? 0;
    return '${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}원';
  }
}
