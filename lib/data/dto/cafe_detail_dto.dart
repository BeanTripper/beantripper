class CafeDetailDto {
  String id;
  String name;
  String address;
  double lat;
  double lng;
  String? operatingTime;
  String? tel;

  CafeDetailDto({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.operatingTime,
    required this.tel,
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
    };
  }
}
