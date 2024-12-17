import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '9.dart';

class RideInputPage extends StatefulWidget {
  const RideInputPage({Key? key}) : super(key: key);

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
        final List<NLatLng> routeCoords = path.map((point) => NLatLng(point[1], point[0])).toList();
        _midPoint = routeCoords[(routeCoords.length / 2).floor()];

        final polyline = NPolylineOverlay(
          id: 'route_line',
          coords: routeCoords,
          color: Colors.blue,
          width: 4,
        );

        final midMarker = NMarker(
          id: 'mid_marker',
          position: _midPoint!,
          icon: await NOverlayImage.fromWidget(
            widget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                "소요 시간\n${(_durationInSeconds!  / 60000).floor()}분",
             
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            size: const Size(150, 50),
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
        title: const Text('출발지와 도착지 입력'),
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
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: '출발지 입력',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _moveToAddress(value, isStart: true),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: '도착지 입력',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _moveToAddress(value, isStart: false),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: '출발 시간 입력',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(onPressed: _resetInputs, child: const Text('취소')),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(onPressed: _navigateToNextPage, child: const Text('다음')),
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
