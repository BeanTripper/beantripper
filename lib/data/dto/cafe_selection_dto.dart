class Location {
  final String title;
  final String category;
  final String roadAddress;
  final String link;

  Location({
    required this.title,
    required this.category,
    required this.roadAddress,
    required this.link,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      title: json['title'],
      category: json['category'],
      roadAddress: json['roadAddress'],
      link: json['link'],
    );
  }
}