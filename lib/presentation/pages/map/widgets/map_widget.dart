import 'package:bean_tripper/domain/entity/cafe.dart';
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

  final List<Cafe>? cafes;
  final NLatLng latLng;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      onMapReady: (controller) {
        cafes?.forEach((e) {
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
          controller.addOverlay(marker);
        });
      },
    );
  }
}
