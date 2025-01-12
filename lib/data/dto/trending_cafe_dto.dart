import 'package:bean_tripper/domain/entity/trending_cafe.dart';

class TrendingCafeDto {
  final String name;
  final String? imageUrl;
  final String category;

  TrendingCafeDto({
    required this.name,
    this.imageUrl,
    required this.category,
  });

  factory TrendingCafeDto.fromJson(Map<String, dynamic> json) {
    return TrendingCafeDto(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  TrendingCafe toEntity() {
    return TrendingCafe(
      name: name,
      imageUrl: imageUrl,
      category: category,
    );
  }
}
