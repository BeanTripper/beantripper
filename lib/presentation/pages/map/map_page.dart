import 'dart:async';

import 'package:bean_tripper/core/geolocator_helper.dart';
import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:bean_tripper/presentation/pages/map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MapPage> createState() => _ClassNameState();
}

class _ClassNameState extends ConsumerState<MapPage> {
  NLatLng? latlng;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    final position = await GeolocatorHelper.getPositon();
    if (position != null) {
      final vm = ref.read(mapViewModel.notifier);
      latlng = NLatLng(position.latitude, position.longitude);
      await vm.fetchCafes(position.latitude, position.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapViewModel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: latlng == null
          ? Center(child: CircularProgressIndicator())
          : MapWidget(
              cafes: state.cafeList,
              latLng: latlng ?? NLatLng(37.63695556, 127.0277194),
            ),
    );
  }
}
