class CafeDto {
  String id;
  double lat;
  double lng;

  CafeDto({
    required this.id,
    required this.lat,
    required this.lng,
  });

  CafeDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          lat: json['lat'] ?? 0.0,
          lng: json['lng'] ?? 0.0,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
    };
  }
}
