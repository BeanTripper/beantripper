import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:bean_tripper/presentation/pages/map/widgets/cafe_info_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapWidget extends ConsumerWidget {
  const MapWidget({
    super.key,
    required this.latLng,
  });

  final NLatLng latLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    NaverMapController? mapController;

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
        mapController = controller;
        if (mapController != null) {
          await fetchCafeMarkers(ref, context, mapController!, latLng);
        }
      },
      onCameraIdle: () async {
        print("onCameraIdle called");
        if (mapController != null) {
          final cameraPosition = mapController!.nowCameraPosition.target;
          print("Camera idle at: $cameraPosition");
          try {
            await fetchCafeMarkers(
                ref, context, mapController!, cameraPosition);
          } catch (e) {
            print("Error fetching cafe markers: $e");
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

    if (state.cafeList.isEmpty) {
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
