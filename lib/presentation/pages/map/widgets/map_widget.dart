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

  final String? cafeId;
  final NLatLng latLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("지도 빌드해요");

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
        final state = ref.watch(mapViewModel);
        state.mapController = controller;

        await _fetchCafeMarkers(context, ref);
      },
      onCameraIdle: () async {
        await _onCameraIdle(context, ref);
      },
    );
  }

  Future<void> _onCameraIdle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final vm = ref.read(mapViewModel.notifier);
    final state = ref.watch(mapViewModel);
    final mapController = state.mapController;

    if (mapController != null) {
      final cameraPosition = mapController.nowCameraPosition.target;
      final currentPosition = state.currentLatLng;

      if (currentPosition?.latitude != cameraPosition.latitude ||
          currentPosition?.longitude != cameraPosition.longitude) {
        await vm.fetchCafes(cameraPosition.latitude, cameraPosition.longitude);
        vm.setCurrentLatLng(
            NLatLng(cameraPosition.latitude, cameraPosition.longitude));
        await _fetchCafeMarkers(context, ref);
      }
    }
  }

  Future<void> _fetchCafeMarkers(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final vm = ref.read(mapViewModel.notifier);
    final state = ref.watch(mapViewModel);
    final mapController = state.mapController;

    if (mapController != null) {
      await vm.fetchCafes(latLng.latitude, latLng.longitude);

      if (state.cafeList.isNotEmpty) {
        mapController.clearOverlays();
      }

      for (var e in state.cafeList) {
        final marker = NMarker(id: e.id, position: NLatLng(e.lat, e.lng));
        marker.setOnTapListener((overlay) async {
          await vm.fetchCafeItem(e.id);

          // 상태 변경 후 watch로 상태 반영
          final selectedCafe =
              ref.watch(mapViewModel.select((s) => s.selectedCafe));
          print("SELECTEDCAFE== ${selectedCafe?.id}, ${selectedCafe?.name}");

          showModalBottomSheet(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            barrierColor: Color.fromRGBO(0, 0, 0, 0),
            context: context,
            builder: (context) => CafeInfoBottomSheet(cafe: selectedCafe),
          );
        });
        mapController.addOverlay(marker);
      }
    }
  }
}
