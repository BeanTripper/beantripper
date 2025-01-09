class CafeDto {
  String id;
  double lat;
  double lng;
  String address;
  String name;
  String operatingTime;
  String tel;

  CafeDto({
    required this.id,
    required this.lat,
    required this.lng,
    required this.address,
    required this.name,
    required this.operatingTime,
    required this.tel,
  });

  CafeDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          lat: json['lat'] ?? 0.0,
          lng: json['lng'] ?? 0.0,
          address: json['address'] ?? '',
          name: json['name'] ?? '',
          operatingTime: json['operatingTime'] ?? '',
          tel: json['tel'] ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'address': address,
      'name': name,
      'operatingTime': operatingTime,
      'tel': tel,
    };
  }
}
