import 'dart:async';

import 'package:bean_tripper/core/geolocator_helper.dart';
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
      latlng = NLatLng(position.latitude, position.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arg != null) {
      latlng = NLatLng(arg['lat'], arg['lng']);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: latlng == null
          ? Center(child: CircularProgressIndicator())
          : MapWidget(
              cafeId: arg?['id'],
              latLng: latlng ?? NLatLng(37.63695556, 127.0277194),
            ),
    );
  }
}
