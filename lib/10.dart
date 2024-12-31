import 'package:flutter/material.dart';
import '11.dart';

class CostSharingPage extends StatefulWidget {
  final String totalFare; // 이전 화면에서 전달받은 총 비용
  final String durationInSeconds; // 예상 소요 시간
  final String startLocation; // 출발지
  final String destinationLocation; // 도착지

  const CostSharingPage({
    Key? key,
    required this.totalFare,
    required this.durationInSeconds,
    required this.startLocation,
    required this.destinationLocation,
  }) : super(key: key);

  @override
  State<CostSharingPage> createState() => _CostSharingPageState();
}

class _CostSharingPageState extends State<CostSharingPage> {
  int _numPeople = 2; // 기본 합승 인원 (2명)
  int _sharePerPerson = 0; // 1인당 부담할 금액
  final TextEditingController _requestController = TextEditingController(); // 요청사항 입력 컨트롤러
  final List<String> _suggestions = [
    '조용히 가고 싶어요',
    '짐이 많아요',
    '빠르게 가고 싶어요',
    '동성끼리',
    '성별무관'
  ];
  final Set<String> _selectedSuggestions = {}; // 선택된 요청사항

  @override
  void initState() {
    super.initState();
    _calculateShares(); // 초기 비용 계산
  }

  void _calculateShares() {
    int totalFare = int.tryParse(widget.totalFare) ?? 0; // 총 비용 파싱
    setState(() {
      _sharePerPerson = (totalFare / _numPeople).ceil(); // 1인당 부담 금액 계산
    });
  }

  String _formatDuration(String durationInSeconds) {
    int seconds = int.tryParse(durationInSeconds) ?? 0;
    int minutes = (seconds / 60000).ceil();
    return '${minutes}분';
  }

  void _toggleSuggestion(String suggestion) {
    setState(() {
      if (_selectedSuggestions.contains(suggestion)) {
        _selectedSuggestions.remove(suggestion);
        _requestController.text = _selectedSuggestions.join(', ');
      } else {
        _selectedSuggestions.add(suggestion);
        _requestController.text = _selectedSuggestions.join(', ');
      }
    });
  }

  void _showConfirmationBanner() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '노선을 등록하시겠습니까?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.startLocation} <-> ${widget.destinationLocation}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                '예상 금액: ${_sharePerPerson.toString()}원',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                '예상 소요 시간: ${_formatDuration(widget.durationInSeconds)}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                '요청사항: ${_requestController.text.isNotEmpty ? _requestController.text : "없음"}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context); // 배너 닫기
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 배너 닫기
                        _registerRoute(); // 노선 등록 함수 호출
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        '등록',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _registerRoute() {
    final newRoute = {
      'startLocation': widget.startLocation,
      'destinationLocation': widget.destinationLocation,
      'totalFare': widget.totalFare,
      'duration': _formatDuration(widget.durationInSeconds),
      'request': _requestController.text.isNotEmpty ? _requestController.text : '없음',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteListPage(
          routes: [newRoute], // 새 노선 전달 (기존 노선과 병합 가능)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '요금은 얼마를 나눌까요?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  '총 예상 금액: ${widget.totalFare}원',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    '합승 인원을 선택하세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _numPeople.toDouble(),
                          min: 2,
                          max: 4,
                          divisions: 2,
                          label: '$_numPeople명',
                          activeColor: Colors.blue,
                          inactiveColor: Colors.blue[100],
                          onChanged: (value) {
                            setState(() {
                              _numPeople = value.toInt();
                              _calculateShares();
                            });
                          },
                        ),
                      ),
                      Text(
                        '$_numPeople명',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '1인당 부담 금액',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_sharePerPerson.toString()}원',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '적립 포인트 (1인당)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(_sharePerPerson * 0.05).toStringAsFixed(0)}원',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    '요청사항',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _requestController,
                    decoration: InputDecoration(
                      hintText: '요청사항을 입력하세요',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _suggestions.map((suggestion) {
                      final isSelected = _selectedSuggestions.contains(suggestion);
                      return ChoiceChip(
                        label: Text(suggestion),
                        selected: isSelected,
                        onSelected: (_) => _toggleSuggestion(suggestion),
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _showConfirmationBanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
