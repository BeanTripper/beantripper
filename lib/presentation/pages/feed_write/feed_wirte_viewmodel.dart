import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FeedWriteViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final List<File> selectedImages = [];
  final List<String> categories = [];
  final List<Map<String, dynamic>> searchResults = [];
  String cafeName = '';
  String content = '';

  // 네이버 API 키와 Secret
  final String naverApiKey = dotenv.env['NAVER_API_KEY'] ?? '';
  final String naverApiSecret = dotenv.env['NAVER_API_SECRET'] ?? '';

  final String baseUrl = 'https://naveropenapi.apigw.ntruss.com/map-place/v1/search';

  // 제외할 카페 브랜드 리스트
  final List<String> excludedBrands = [
    '메가MGC커피',
    '이디야커피',
    '컴포즈커피',
    '스타벅스',
    '빽다방',
    '투썸플레이스',
    '더벤티',
    '할리스커피',
    '파스쿠찌',
    '엔제리너스',
    '탐앤탐스',
    '커피빈',
    '폴바셋',
    '커피베이',
    '카페베네',
  ];

  // 카페 이름 설정
  void setCafeName(String value) {
    cafeName = value;
    notifyListeners();
  }

  // 게시글 내용 설정
  void setPostContent(String value) {
    content = value;
    notifyListeners();
  }

  // 태그 선택/해제
  void toggleTagSelection(String tag) {
    if (categories.contains(tag)) {
      categories.remove(tag);
    } else if (categories.length < 3) {
      categories.add(tag);
    } else {
      print('태그는 최대 3개까지 선택 가능합니다.');
    }
    notifyListeners();
  }

  // 이미지 선택
  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images != null) {
      for (var img in images) {
        final file = File(img.path);
        if (!selectedImages.any((element) => element.path == file.path)) {
          selectedImages.add(file);
        }
      }
      if (selectedImages.length > 5) {
        selectedImages.removeRange(5, selectedImages.length);
      }
      notifyListeners();
    }
  }

  // Firestore에 데이터 업로드
  Future<void> uploadDataToFirebase() async {
    if (cafeName.isEmpty || content.isEmpty || categories.isEmpty) {
      throw Exception('모든 필드를 입력해야 합니다.');
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final firestore = FirebaseFirestore.instance;

      // 이미지 업로드
      List<String> imageUrls = [];
      for (var file in selectedImages) {
        final imageRef = storageRef.child('uploads/${file.path.split('/').last}');
        await imageRef.putFile(file);
        final url = await imageRef.getDownloadURL();
        imageUrls.add(url);
      }

      // Firestore에 데이터 저장
      await firestore.collection('feed').add({
        'cafeName': cafeName,
        'categories': categories,
        'content': content,
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Firebase 업로드 중 오류 발생: $e');
      rethrow;
    }
  }

  // 네이버 지도 API로 카페 검색
  Future<void> searchCafes(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      notifyListeners();
      return;
    }

    final url = Uri.parse('$baseUrl?query=$query&coordinate=127.1054328,37.3595963');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-NCP-APIGW-API-KEY-ID': naverApiKey,
          'X-NCP-APIGW-API-KEY': naverApiSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final places = data['places'] as List;

        // 결과 필터링
        searchResults
          ..clear()
          ..addAll(places.where((place) {
            final name = place['name'] as String;
            return !excludedBrands.any((brand) => name.contains(brand));
          }).map((place) {
            return {
              'name': place['name'],
              'address': place['road_address'] ?? place['jibun_address'],
              'lat': place['x'],
              'lng': place['y'],
              'tel': place['telephone'] ?? '',
            };
          }));

        notifyListeners();
      } else {
        print('네이버 지도 API 호출 실패: ${response.body}');
        throw Exception('Failed to fetch cafes');
      }
    } catch (e) {
      print('카페 검색 중 오류 발생: $e');
    }
  }
}
