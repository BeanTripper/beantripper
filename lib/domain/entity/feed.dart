import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  String id;
  String content;
  String cafeId;
  String cafeName;
  String writerId;
  String writerName;
  Timestamp createdAt; // Timestamp 타입으로 수정
  List<String> imageUrls; // imageUrls 필드 추가
  List<String> categories; // categories 필드 추가

  Feed({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.writerId,
    required this.writerName,
    required this.createdAt,
    required this.imageUrls, // 필드 초기화 추가
    required this.categories, // 필드 초기화 추가
  });

  factory Feed.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Feed(
      id: doc.id,
      content: data['content'] ?? '',
      cafeId: data['cafeId'] ?? '',
      cafeName: data['cafeName'] ?? '',
      writerId: data['writerId'] ?? '',
      writerName: data['writerName'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []), // 배열 변환 로직 추가
      categories: List<String>.from(data['categories'] ?? []), // 배열 변환 로직 추가
    );
  }
}
