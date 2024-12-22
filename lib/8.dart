import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '9.dart';

class RideInputPage extends StatefulWidget {const RideInputPage({Key? key}) : super(key: key);

  @override
  State<RideInputPage> createState() => _RideInputPageState();
}

class _RideInputPageState extends State<RideInputPage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  late NaverMapController _mapController;

  NMarker? _startMarker;
  NMarker? _destinationMarker;
  NPolylineOverlay? _routeLine; // 경로선
  bool _routeDrawn = false; // 경로가 그려졌는지 확인
  int? _durationInSeconds; // 소요 시간 (초 단위)
  NLatLng? _midPoint; // 경로 중간 지점

  // **택시 요금 계산 함수 추가**
  double _calculateTaxiFare(int distanceInMeters, int durationInSeconds) {
    const int baseFare = 4800; // 기본 요금 (최초 2km)
    const int baseDistance = 2000; // 기본 거리 (2km)
    const int farePer100m = 100; // 100m당 요금
    const int farePer30Sec = 100; // 30초당 요금

    double totalFare = baseFare.toDouble();

    // 거리 요금 계산
    if (distanceInMeters > baseDistance) {
      int extraDistance = distanceInMeters - baseDistance;
      totalFare += (extraDistance / 100).ceil() * farePer100m;//얘도 아닌듯듯
    }

    // 시간 요금 계산 (30초당 100원)
    

    totalFare += (durationInSeconds / 30000).ceil() * farePer30Sec;//얜 아님

    return totalFare;
  }

  Future<void> _moveToAddress(String address, {required bool isStart}) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;

        await _mapController.updateCamera(
          NCameraUpdate.withParams(
            target: NLatLng(location.latitude, location.longitude),
            zoom: 16,
          ),
        );

        final newMarker = NMarker(
          id: isStart ? 'start_marker' : 'destination_marker',
          position: NLatLng(location.latitude, location.longitude),
          caption: NOverlayCaption(
            text: isStart ? '출발지' : '도착지',
            textSize: 12,
          ),
        );

        setState(() {
          if (isStart) {
            if (_startMarker != null) {
              _mapController.deleteOverlay(
                NOverlayInfo(type: NOverlayType.marker, id: _startMarker!.info.id),
              );
            }
            _startMarker = newMarker;
          } else {
            if (_destinationMarker != null) {
              _mapController.deleteOverlay(
                NOverlayInfo(type: NOverlayType.marker, id: _destinationMarker!.info.id),
              );
            }
            _destinationMarker = newMarker;
          }
          _mapController.addOverlay(newMarker);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("입력한 장소를 찾을 수 없습니다.")),
        );
      }
    } catch (e) {
      print("주소 변환 실패: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("장소 검색 중 오류가 발생했습니다.")),
      );
    }
  }

  Future<void> _fetchAndDrawRoute() async {
    if (_startMarker == null || _destinationMarker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("출발지와 도착지를 모두 입력해 주세요.")),
      );
      return;
    }

    final startPosition = _startMarker!.position;
    final destinationPosition = _destinationMarker!.position;

    try {
      final String baseUrl = "https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving";
      final String url =
          "$baseUrl?start=${startPosition.longitude},${startPosition.latitude}&goal=${destinationPosition.longitude},${destinationPosition.latitude}&option=traoptimal";

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              "X-NCP-APIGW-API-KEY-ID": "v2dyhbtaq4",
              "X-NCP-APIGW-API-KEY": "o0cMSfneFAhgulLXyUcl5DyxecfFUEIX23aJLkZ3",
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final route = decodedData['route']['traoptimal'][0];
        final List<dynamic> path = route['path'];
        final summary = route['summary'];

        _durationInSeconds = summary['duration'];
        final int distance = summary['distance']; // 이동 거리 (미터)
        double taxiFare = _calculateTaxiFare(distance, _durationInSeconds!);

        final List<NLatLng> routeCoords = path.map((point) => NLatLng(point[1], point[0])).toList();
        _midPoint = routeCoords[(routeCoords.length / 2).floor()];

        final polyline = NPolylineOverlay(
          id: 'route_line',
          coords: routeCoords,
          color: Colors.blue,
          width: 6,
        );

        final midMarker = NMarker(
          id: 'mid_marker',
          position: _midPoint!,
          icon: await NOverlayImage.fromWidget(
            widget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "소요 시간: ${(_durationInSeconds! / 60000).floor()}분\n택시 비용: ${taxiFare.toInt()}원",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            size: const Size(140, 40),
            context: context,
          ),
        );

        setState(() {
          _routeLine = polyline;
          _mapController.addOverlay(polyline);
          _mapController.addOverlay(midMarker);
          _routeDrawn = true;
        });

        final bounds = NLatLngBounds.from(routeCoords);
        await _mapController.updateCamera(NCameraUpdate.fitBounds(bounds));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("경로를 가져오는 데 실패했습니다.")),
        );
      }
    } catch (e) {
      print("경로 가져오기 오류: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("경로 요청 중 오류가 발생했습니다.")),
      );
    }
  }

  // 나머지 코드는 그대로 유지됩니다.
 void _navigateToNextPage() {
    if (!_routeDrawn) {
      _fetchAndDrawRoute();
    } else {
      if (_timeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("출발 시간을 입력해 주세요.")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RouteRegistrationPage(
            startLocation: _startController.text,
            destinationLocation: _destinationController.text,
            departureTime: _timeController.text,
            durationInSeconds: _durationInSeconds != null ? _durationInSeconds.toString() : '0',
            totalFare: _calculateTaxiFare(0, _durationInSeconds ?? 0).toStringAsFixed(0),//원래 taxifare임임
          ),
        ),
      );
    }
  }

  void _resetInputs() {
    setState(() {
      _startController.clear();
      _destinationController.clear();
      _timeController.clear();

      _mapController.clearOverlays();
      _startMarker = null;
      _destinationMarker = null;
      _routeLine = null;
      _routeDrawn = false;
      _durationInSeconds = null;
      _midPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: NaverMap(
              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.5666102, 126.9783881),
                  zoom: 14,
                ),
              ),
              onMapReady: (controller) {
                _mapController = controller;
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, -2))],
              ),
              child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    // 출발지 입력
    Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _startController,
        decoration: InputDecoration(
          hintText: '출발지 입력',
          prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onSubmitted: (value) => _moveToAddress(value, isStart: true),
      ),
    ),

    // 도착지 입력
    Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _destinationController,
        decoration: InputDecoration(
          hintText: '도착지 입력',
          prefixIcon: const Icon(Icons.flag, color: Colors.red),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onSubmitted: (value) => _moveToAddress(value, isStart: false),
      ),
    ),

    // 출발 시간 입력
    Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _timeController,
        decoration: InputDecoration(
          hintText: '출발 시간 입력',
          prefixIcon: const Icon(Icons.access_time, color: Colors.green),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        keyboardType: TextInputType.datetime,
      ),
    ),

    // 버튼 Row
    Row(
      children: [
        // 취소 버튼
        Expanded(
          child: GestureDetector(
            onTap: _resetInputs,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent, width: 1.5),
              ),
              child: const Center(
                child: Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 다음 버튼
        Expanded(
          child: GestureDetector(
            onTap: _navigateToNextPage,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF6D5DF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '다음',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ],
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