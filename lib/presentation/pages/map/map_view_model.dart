import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapViewModel extends Notifier<List<Cafe>> {
  @override
  List<Cafe> build() {
    fetchCafes();
    return [];
  }

  Future<void> fetchCafes() async {
    final cafes = await ref.read(fetchCafesListUsecaseProvider).excute();
    cafes?.forEach((element) {
      print(
          "CAFE== id: ${element.id}, lat: ${element.lat}, lng: ${element.lng}");
    });
    print(cafes?.length);
    state = cafes ?? [];
  }
}

final mapViewModel =
    NotifierProvider<MapViewModel, List<Cafe>>(() => MapViewModel());
