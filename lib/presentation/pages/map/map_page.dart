import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatelessWidget {
  // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: NaverMap(
        options: const NaverMapViewOptions(
          locationButtonEnable: true,
          consumeSymbolTapEvents: true,
        ),
        onMapReady: (controller) {
          // Completer에 지도 컨트롤러 완료 신호 전송
          mapControllerCompleter.complete(controller);
        },
      ),
    );
  }
}
