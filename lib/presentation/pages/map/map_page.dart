import 'dart:async';

import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(mapViewModel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: MapWidget(cafes: vm.cafeList),
    );
  }
}
