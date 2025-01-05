class CafeDto {
  int id;
  String name;
  String address;
  String? operatingTime;
  String? tel;

  CafeDto({
    required this.id,
    required this.name,
    required this.address,
    required this.operatingTime,
    required this.tel,
  });

  CafeDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          address: json['address'] ?? '',
          operatingTime: json['operatingTime'],
          tel: json['tel'],
        );
}
