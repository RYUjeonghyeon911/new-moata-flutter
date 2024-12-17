import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geocoding/geocoding.dart';

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

  void _drawRoute() async {
    if (_startMarker == null || _destinationMarker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("출발지와 도착지를 모두 입력해 주세요.")),
      );
      return;
    }

    // 출발지와 도착지 좌표 가져오기
    final startPosition = _startMarker!.position;
    final destinationPosition = _destinationMarker!.position;

      // 기존 경로선 제거
    //if (_routeLine != null) {
      //_mapController.deleteOverlay(NOverlayInfo(type: NOverlayType.polyline, id: _routeLine!.info.id));
    //}

    // 경로선 생성
    final polyline = NPolylineOverlay(
      id: 'route_line',
      coords: [startPosition, destinationPosition],
      color: Colors.red,
      width: 4,
    );

    setState(() {
      _routeLine = polyline;
      _mapController.addOverlay(polyline);
    });

    // 출발지와 도착지를 모두 포함하는 화면 이동
    final bounds = NLatLngBounds.from([startPosition, destinationPosition]);
    await _mapController.updateCamera(NCameraUpdate.fitBounds(bounds));
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
          // 네이버 지도
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
          // 입력 필드 및 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 출발지 입력
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: '출발지 입력',
                      hintText: '출발지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _moveToAddress(value, isStart: true),
                  ),
                  const SizedBox(height: 12),
                  // 도착지 입력
                  TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: '도착지 입력',
                      hintText: '도착지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _moveToAddress(value, isStart: false),
                  ),
                  const SizedBox(height: 12),
                  // 출발 시간 입력
                  TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(
                      labelText: '출발 시간 입력',
                      hintText: '출발 시간을 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  // 취소 및 확인 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _resetInputs,
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _drawRoute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('확인'),
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