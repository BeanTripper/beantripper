class UserDto {
  String id;
  String name;

  UserDto({
    required this.id,
    required this.name,
  });

  factory UserDto.fromJson(Map<String, dynamic> map) =>
      UserDto(id: map['id'], name: map['name']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
