import 'package:bean_tripper/domain/entity/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feed {
  String id;
  String content;
  String cafeId;
  String cafeName;
  String writerId;
  String writerName;
  Timestamp createdAt;
  List<String> imageUrls;
  List<String> categories;
  List<User>? popularList;
  List<Comment>? commentList;

  Feed({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.writerId,
    required this.writerName,
    required this.createdAt,
    required this.imageUrls,
    required this.categories,
    this.commentList,
    this.popularList,
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
      createdAt: data['createdAt'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      popularList: data['popularList'] != null
          ? List<User>.from((data['popularList'] as List)
              .map((user) => User.fromFirestore(user)))
          : [],
      commentList: data['commentList'] != null
          ? List<Comment>.from((data['commentList'] as List)
              .map((comment) => Comment.fromFirestore(comment)))
          : [],
    );
  }

  int get popularCount => popularList?.length ?? 0;
  int get commentCount => commentList?.length ?? 0;
}

class User {
  String id;
  String name;

  User({required this.id, required this.name});

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }
}

class Comment {
  String userId;
  String content;
  Timestamp createdAt;

  Comment(
      {required this.userId, required this.content, required this.createdAt});

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }
}
