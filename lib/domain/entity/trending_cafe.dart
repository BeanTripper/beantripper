class TrendingCafe {
  final String name;
  final String? imageUrl;
  final String category;

  TrendingCafe({
    required this.name,
    this.imageUrl,
    required this.category,
  });

  // 복사본 생성을 위한 copyWith 메서드
  TrendingCafe copyWith({
    String? name,
    String? imageUrl,
    String? category,
  }) {
    return TrendingCafe(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendingCafe &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          imageUrl == other.imageUrl &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode ^ category.hashCode;
}
