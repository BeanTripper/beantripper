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
  bool isReported; // 신고 여부 필드 추가

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
    this.isReported = false, // 기본 값 설정
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
        isReported: false, // 기본 값 설정
      );
    }

    final data = doc.data() as Map<String, dynamic>;

    final userData = data['user'] as Map<String, dynamic>?;

    return Feed(
      id: doc.id,
      content: data['content'] ?? '',
      cafeId: data['cafeId'] ?? '',
      cafeName: data['cafeName'] ?? '',
      userId: userData?['userId'] ?? data['userId'] ?? '',
      userName: userData?['name'] ?? data['userName'] ?? '',
      userProfile: userData?['profile'] ?? data['profile'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      popularList: data['popularList'] != null
          ? List<UserDto>.from((data['popularList'] as List)
              .map((user) => UserDto.fromJson(user)))
          : [],
      commentList: data['commentList'] != null
          ? List<Comment>.from((data['commentList'] as List)
              .map((comment) => Comment.fromFirestore(comment)))
          : [],
      isReported: data['isReported'] ?? false, // 신고 여부 필드 추가
    );
  }

  int get popularCount => popularList?.length ?? 0;
  int get commentCount => commentList?.length ?? 0;
}

class Comment {
  String userId;
  String content;
  Timestamp createdAt;
  bool isReported; // 신고 여부 필드 추가

  Comment({
    required this.userId,
    required this.content,
    required this.createdAt,
    this.isReported = false, // 기본 값 설정
  });

  factory Comment.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) {
      return Comment(
        userId: '',
        content: '',
        createdAt: Timestamp.now(),
        isReported: false, // 기본 값 설정
      );
    }
    return Comment(
      userId: data['userId'] ?? '', // 기본 값 설정
      content: data['content'] ?? '', // 기본 값 설정
      createdAt: data['createdAt'] ?? Timestamp.now(), // 기본 값 설정
      isReported: data['isReported'] ?? false, // 신고 여부 필드 추가
    );
  }
}
