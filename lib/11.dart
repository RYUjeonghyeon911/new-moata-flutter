import 'package:flutter/material.dart';
import '8.dart'; // RideInputPage import

class RouteListPage extends StatefulWidget {
  final List<Map<String, String>> routes; // 등록된 노선 정보 리스트

  const RouteListPage({Key? key, required this.routes}) : super(key: key);

  @override
  State<RouteListPage> createState() => _RouteListPageState();
}

class _RouteListPageState extends State<RouteListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '등록된 노선',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              // RideInputPage로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RideInputPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: widget.routes.isEmpty
          ? const Center(
              child: Text(
                '등록된 노선이 없습니다.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.routes.length,
              itemBuilder: (context, index) {
                final route = widget.routes[index];
                return _buildRouteCard(route);
              },
            ),
    );
  }

  Widget _buildRouteCard(Map<String, String> route) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 출발지 → 도착지
          Text(
            '${route['startLocation']} → ${route['destinationLocation']}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // 예상 금액
          Text(
            '예상 금액: ${route['totalFare']}원',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          // 예상 소요 시간
          Text(
            '예상 소요 시간: ${route['duration']}',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          // 요청사항
          Text(
            '요청사항: ${route['request']}',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}