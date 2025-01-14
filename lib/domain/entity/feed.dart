import 'package:bean_tripper/domain/entity/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_tripper/data/dto/user_dto.dart'; // user_dto 파일 경로 수정

class Feed {
  String id;
  String content;
  String cafeId;
  String cafeName;
  String userId;
  String userName;
  String userProfile; // 프로필 필드 추가
  Timestamp createdAt;
  List<String> imageUrls;
  List<String> categories;
  List<UserDto>? popularList;
  List<Comment>? commentList;

  Feed({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.userId,
    required this.userName,
    required this.userProfile, // 프로필 필드 추가
    required this.createdAt,
    required this.imageUrls,
    required this.categories,
    this.commentList,
    this.popularList,
  });

  factory Feed.fromFirestore(DocumentSnapshot doc) {
    if (doc.data() == null) {
      return Feed(
        id: doc.id,
        content: '',
        cafeId: '',
        cafeName: '',
        userId: '',
        userName: '',
        userProfile: '',
        createdAt: Timestamp.now(),
        imageUrls: [],
        categories: [],
        popularList: [],
        commentList: [],
      );
    }

    final data = doc.data() as Map<String, dynamic>; // null 허용
    return Feed(
      id: doc.id,
      content: data['content'] ?? '', // 기본 값 설정
      cafeId: data['cafeId'] ?? '', // 기본 값 설정
      cafeName: data['cafeName'] ?? '', // 기본 값 설정
      userId: data['userId'] ?? '', // 기본 값 설정
      userName: data['userName'] ?? '', // 기본 값 설정
      userProfile: data['userProfile'] ?? '', // 기본 값 설정
      createdAt: data['createdAt'] ?? Timestamp.now(), // 기본 값 설정
      imageUrls: List<String>.from(data['imageUrls'] ?? []), // 기본 값 설정
      categories: List<String>.from(data['categories'] ?? []), // 기본 값 설정
      popularList: data['popularList'] != null
          ? List<UserDto>.from((data['popularList'] as List)
              .map((user) => UserDto.fromJson(user)))
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

class Comment {
  String userId;
  String content;
  Timestamp createdAt;

  Comment({
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) {
      return Comment(
        userId: '',
        content: '',
        createdAt: Timestamp.now(),
      );
    }
    return Comment(
      userId: data['userId'] ?? '', // 기본 값 설정
      content: data['content'] ?? '', // 기본 값 설정
      createdAt: data['createdAt'] ?? Timestamp.now(), // 기본 값 설정
    );
  }
}
