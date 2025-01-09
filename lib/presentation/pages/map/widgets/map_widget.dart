import 'package:bean_tripper/domain/entity/cafe_marker.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:bean_tripper/presentation/pages/map/widgets/cafe_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapWidget extends ConsumerWidget {
  const MapWidget({
    required this.cafes,
    required this.latLng,
  });

  final List<CafeMarker>? cafes;
  final NLatLng latLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapViewModel);
    NaverMapController? _mapController;

    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: latLng,
          zoom: 13.5,
        ),
        locationButtonEnable: true,
        consumeSymbolTapEvents: true,
      ),
      onMapReady: (controller) {
        _mapController = controller;
        cafes?.forEach((e) {
          print("삐용~~");
          final marker = NMarker(id: e.id, position: NLatLng(e.lat, e.lng));
          marker.setOnTapListener((overlay) async {
            print("마커 터치 ${e.id}");

            await ref.read(mapViewModel.notifier).fetchCafeItem(e.id);
            final selectedCafe = ref.read(mapViewModel).selectedCafe;

            showModalBottomSheet(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              barrierColor: Color.fromRGBO(0, 0, 0, 0),
              context: context,
              builder: (context) => CafeInfoBottomSheet(cafe: selectedCafe),
            );
          });
          _mapController!.addOverlay(marker);
        });
      },
      onCameraIdle: () {
        final cameraPosition = _mapController!.nowCameraPosition.target;
        print(cameraPosition);
        // final vm = ref.watch(mapViewModel.notifier);
        // vm.fetchCafes(cameraPosition.latitude, cameraPosition.longitude);
      },
    );
  }
}
