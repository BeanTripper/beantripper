import 'package:bean_tripper/domain/entity/cafe_marker.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapState {
  List<CafeMarker> cafeList;
  CafeDetail? selectedCafe;
  NaverMapController? mapController;
  NLatLng? currentLatLng;

  MapState({
    required this.cafeList,
    required this.selectedCafe,
    required this.mapController,
    required this.currentLatLng,
  });
}

class MapViewModel extends Notifier<MapState> {
  @override
  MapState build() {
    // fetchCafes();
    return MapState(
      cafeList: [],
      selectedCafe: null,
      mapController: null,
      currentLatLng: null,
    );
  }

  void setMapController(NaverMapController controller) {
    state = MapState(
      cafeList: state.cafeList,
      selectedCafe: state.selectedCafe,
      mapController: controller,
      currentLatLng: state.currentLatLng,
    );
  }

  void setCurrentLatLng(NLatLng currentLatLng) {
    state = MapState(
      cafeList: state.cafeList,
      selectedCafe: state.selectedCafe,
      mapController: state.mapController,
      currentLatLng: currentLatLng,
    );
  }

  Future<void> fetchCafes(double lat, double lng) async {
    final cafes =
        await ref.read(fetchCafesListUsecaseProvider).excute(lat, lng);
    cafes?.forEach((element) {
      print(
          "CAFE== id: ${element.id}, lat: ${element.lat}, lng: ${element.lng}");
    });
    print(cafes?.length);
    state = MapState(
      cafeList: cafes ?? [],
      selectedCafe: state.selectedCafe,
      mapController: state.mapController,
      currentLatLng: state.currentLatLng,
    );
  }

  Future<void> fetchCafeItem(String id) async {
    final cafe = await ref.read(fetchCafeItemUsecaseProvider).excute(id);
    print("SELECTEDCAFE== ${cafe?.id}, ${cafe?.name}");
    state = MapState(
      cafeList: state.cafeList,
      selectedCafe: cafe,
      mapController: state.mapController,
      currentLatLng: state.currentLatLng,
    );
  }
}

final mapViewModel =
    NotifierProvider<MapViewModel, MapState>(() => MapViewModel());
