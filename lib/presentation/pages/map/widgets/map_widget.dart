import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:bean_tripper/presentation/pages/map/widgets/cafe_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapWidget extends ConsumerWidget {
  MapWidget({
    required this.cafeId,
    required this.latLng,
  });

  String? cafeId;
  NLatLng latLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(mapViewModel.notifier);
    final state = ref.watch(mapViewModel);

    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: latLng,
          zoom: 13.5,
        ),
        locationButtonEnable: true,
        consumeSymbolTapEvents: true,
      ),
      onMapReady: (controller) async {
        state.mapController = controller;
        if (state.mapController != null) {
          await fetchCafeMarkers(ref, context, state.mapController!, latLng);
        }
      },
      onCameraIdle: () async {
        print("onCameraIdle called");
        if (state.mapController != null) {
          final cameraPosition = state.mapController!.nowCameraPosition.target;
          if (state.currentLatLng?.latitude != cameraPosition.latitude &&
              state.currentLatLng?.longitude != cameraPosition.longitude) {
            await fetchCafeMarkers(
                ref, context, state.mapController!, cameraPosition);
            vm.setCurrentLatLng(
                NLatLng(cameraPosition.latitude, cameraPosition.longitude));
          }
        } else {
          print("controller is null");
        }
      },
    );
  }

  Future<void> fetchCafeMarkers(
    WidgetRef ref,
    BuildContext context,
    NaverMapController mapController,
    NLatLng targetLatLng,
  ) async {
    final vm = ref.read(mapViewModel.notifier);
    await vm.fetchCafes(targetLatLng.latitude, targetLatLng.longitude);

    final state = ref.watch(mapViewModel);

    if (state.cafeList.isNotEmpty) {
      print("지워용~~");
      mapController.clearOverlays();
    }

    print("삐용~~");
    for (var e in state.cafeList) {
      final marker = NMarker(id: e.id, position: NLatLng(e.lat, e.lng));
      marker.setOnTapListener((overlay) async {
        print("마커 터치 ${e.id}");

        await vm.fetchCafeItem(e.id);
        final selectedCafe = ref.read(mapViewModel).selectedCafe;

        showModalBottomSheet(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          barrierColor: Color.fromRGBO(0, 0, 0, 0),
          context: context,
          builder: (context) => CafeInfoBottomSheet(cafe: selectedCafe),
        );
      });
      mapController.addOverlay(marker);
    }
    print("끗~~");
  }
}
