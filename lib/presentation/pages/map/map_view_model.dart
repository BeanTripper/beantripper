import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapState {
  List<Cafe> cafeList;
  CafeDetail? selectedCafe;

  MapState({
    required this.cafeList,
    required this.selectedCafe,
  });
}

class MapViewModel extends Notifier<MapState> {
  @override
  MapState build() {
    // fetchCafes();
    return MapState(cafeList: [], selectedCafe: null);
  }

  Future<void> fetchCafes(double lat, double lng) async {
    final cafes =
        await ref.read(fetchCafesListUsecaseProvider).excute(lat, lng);
    cafes?.forEach((element) {
      print(
          "CAFE== id: ${element.id}, lat: ${element.lat}, lng: ${element.lng}");
    });
    print(cafes?.length);
    state = MapState(cafeList: cafes ?? [], selectedCafe: state.selectedCafe);
  }

  Future<void> fetchCafeItem(String id) async {
    final cafe = await ref.read(fetchCafeItemUsecaseProvider).excute(id);
    print("SELECTEDCAFE== ${cafe?.id}, ${cafe?.name}");
    state = MapState(cafeList: state.cafeList, selectedCafe: cafe);
  }
}

final mapViewModel =
    NotifierProvider<MapViewModel, MapState>(() => MapViewModel());
