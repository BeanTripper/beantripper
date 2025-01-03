import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends Notifier<int> {
  @override
  build() {
    return 0;
  }

  void onIndexChanged(int newIndex) {
    state = newIndex;
  }
}

final homeViewModel = NotifierProvider<HomeViewModel, int>(
  () {
    return HomeViewModel();
  },
);
