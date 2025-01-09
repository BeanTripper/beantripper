import 'package:geolocator/geolocator.dart';

class GeolocatorHelper {
  static bool _idDenied(LocationPermission permission) {
    return permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever;
  }

  static Future<Position?> getPositon() async {
    final permission = await Geolocator.checkPermission();
    if (_idDenied(permission)) {
      final request = await Geolocator.requestPermission();
      if (_idDenied(request)) {
        return null;
      }
    }

    final LocationSettings locationSettings = LocationSettings(
      // 위치정확도
      accuracy: LocationAccuracy.high,
      // 업데이트에 필요한 이동거리(미터 단위)
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    return position;
  }
}
