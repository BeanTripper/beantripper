class CafeDetail {
  String id;
  String name;
  String address;
  double lat;
  double lng;
  String? operatingTime;
  String? tel;
  String? feedImageUrls;

  CafeDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.operatingTime,
    required this.tel,
    required this.feedImageUrls,
  });
}
