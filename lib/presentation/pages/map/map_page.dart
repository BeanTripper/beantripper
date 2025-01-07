import 'dart:async';

import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(mapViewModel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          naverMap(vm, context),
          // bottomSheetContainer(),
        ],
      ),
    );
  }

  NaverMap naverMap(List<Cafe>? cafes, BuildContext context) {
    return NaverMap(
      options: const NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(35.2347, 126.9816),
          zoom: 13.5,
        ),
        locationButtonEnable: true,
        consumeSymbolTapEvents: true,
      ),
      onMapReady: (controller) {
        cafes?.forEach((e) {
          final marker = NMarker(id: e.id, position: NLatLng(e.lat, e.lng));
          marker.setOnTapListener((overlay) {
            print("마커 터치 ${e.id}");

            final item = CafeDetail(
              id: 'id',
              name: 'name',
              address: 'address',
              lat: 0,
              lng: 0,
              operatingTime: 'operatingTime',
              tel: 'tel',
            );

            showModalBottomSheet(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              barrierColor: Color.fromRGBO(0, 0, 0, 0),
              context: context,
              builder: (context) => bottomSheetContainer(item, context),
            );
          });
          controller.addOverlay(marker);
        });
      },
    );
  }

  Widget bottomSheetContainer(CafeDetail cafe, BuildContext context) {
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
                cafe.name,
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
                        cafe.operatingTime ?? '',
                        style: TextStyle(color: CustomColors.brown),
                      ),
                      Text(cafe.tel ?? ''),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cafe_detail_page');
                    },
                    child: Text('상세보기'),
                  ),
                ],
              ),
              Text(
                cafe.address,
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
