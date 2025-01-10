import 'dart:async';

import 'package:bean_tripper/core/geolocator_helper.dart';
import 'package:bean_tripper/presentation/pages/map/map_view_model.dart';
import 'package:bean_tripper/presentation/pages/map/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapPage extends ConsumerWidget {
  const MapPage({Key? key}) : super(key: key);

  Future<NLatLng?> _fetchAddress() async {
    final position = await GeolocatorHelper.getPositon();
    if (position != null) {
      return NLatLng(position.latitude, position.longitude);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arg = ModalRoute.of(context)?.settings.arguments as Map?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cafe Name'),
      ),
      body: FutureBuilder<NLatLng?>(
        future: _fetchAddress(),
        builder: (context, snapshot) {
          if (ref.watch(mapViewModel).mapController == null &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final latlng = arg != null
                ? NLatLng(arg['lat'], arg['lng'])
                : snapshot.data ?? NLatLng(37.63695556, 127.0277194);
            return MapWidget(
              cafeId: arg?['id'],
              latLng: latlng,
            );
          }
        },
      ),
    );
  }
}
