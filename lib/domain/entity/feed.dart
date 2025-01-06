import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  int id;
  String content;
  String cafeId;
  String cafeName;
  String writerId;
  String writerName;
  String createdAt;
  String imageUrl; // imageUrl 필드 추가
  String description; // description 필드 추가

  Feed({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.writerId,
    required this.writerName,
    required this.createdAt,
    required this.imageUrl, // 필드 초기화 추가
    required this.description, // 필드 초기화 추가
  });

  factory Feed.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Feed(
      id: data['id'] ?? 0,
      content: data['content'] ?? '',
      cafeId: data['cafeId'] ?? '',
      cafeName: data['cafeName'] ?? '',
      writerId: data['writerId'] ?? '',
      writerName: data['writerName'] ?? '',
      createdAt: data['createdAt'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // 데이터 변환 로직 추가
      description: data['description'] ?? '', // 데이터 변환 로직 추가
    );
  }
}
