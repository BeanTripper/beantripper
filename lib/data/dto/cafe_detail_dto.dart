class CafeDetailDto {
  String id;
  String name;
  String address;
  double lat;
  double lng;
  String? operatingTime;
  String? tel;
  String? feedImageUrls;

  CafeDetailDto({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.operatingTime,
    required this.tel,
    required this.feedImageUrls,
  });

  CafeDetailDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          address: json['address'] ?? '',
          lat: json['lat'] ?? 0.0,
          lng: json['lng'] ?? 0.0,
          operatingTime: json['operatingTime'],
          tel: json['tel'],
          feedImageUrls: json['feedImageUrls'],
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'operatingTime': operatingTime,
      'tel': tel,
      'feedImageUrls': feedImageUrls,
    };
  }
}
