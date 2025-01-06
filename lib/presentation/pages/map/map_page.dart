import 'dart:async';

import 'package:bean_tripper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapPage extends StatelessWidget {
  // NaverMapController 객체의 비동기 작업 완료를 나타내는 Completer
  // final Completer<NaverMapController> mapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(35.2347, 126.9816),
                zoom: 13.5,
              ),
              locationButtonEnable: true,
              consumeSymbolTapEvents: true,
            ),
            onMapReady: (controller) {
              // Completer에 지도 컨트롤러 완료 신호 전송
              final marker1 =
                  NMarker(id: '1', position: NLatLng(35.2347, 126.9816));
              marker1.setOnTapListener(
                (overlay) {
                  print('마커 터치');
                },
              );
              // mapControllerCompleter.complete(controller);
              controller.addOverlay(marker1);
            },
          ),
          bottomSheetContainer(),
        ],
      ),
    );
  }

  Widget bottomSheetContainer() {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '카페 이름',
                style: TextStyle(
                  fontSize: 20,
                  color: CustomColors.brown,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '영업시간: 8:00 ~ 22:00',
                        style: TextStyle(color: CustomColors.brown),
                      ),
                      Text('02-1234-5678'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('상세보기'),
                  ),
                ],
              ),
              Text(
                'tjdnfxmrquftl tjchrn qksvhehd 11-2',
                style: TextStyle(color: CustomColors.brown),
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
