import 'dart:convert';

class UserDto {
  final String id;
  final String name;
  final String profile;

  UserDto({
    required this.id,
    required this.name,
    required this.profile,
  });

  UserDto copyWith({
    String? id,
    String? name,
    String? profile,
  }) =>
      UserDto(
        id: id ?? this.id,
        name: name ?? this.name,
        profile: profile ?? this.profile,
      );

  factory UserDto.fromRawJson(String str) => UserDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json["id"],
        name: json["name"],
        profile: json["profile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profile": profile,
      };
}
