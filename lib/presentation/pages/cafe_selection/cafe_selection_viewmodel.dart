import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeSelectionViewModel extends ChangeNotifier {
  final String naverApiKey = '<NAVER_API_KEY>';
  final String naverApiSecret = '<NAVER_API_SECRET>';
  final String baseUrl = "https://openapi.naver.com/v1/search/local.json";

  final List<Map<String, dynamic>> searchResults = [];
  Map<String, dynamic>? selectedCafe;
  bool isLoading = false;

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

  // 카페 검색
  Future<void> searchCafes(String query) async {
    if (query.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl?query=$query&display=20');
      final response = await http.get(
        url,
        headers: {
          'X-Naver-Client-Id': naverApiKey,
          'X-Naver-Client-Secret': naverApiSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];
        searchResults.clear();

        searchResults.addAll(items.where((item) {
          final name = item['title'] as String;
          return !excludedBrands.any((brand) => name.contains(brand));
        }).map((item) {
          return {
            'name': _stripHtmlTags(item['title']),
            'address': item['roadAddress'] ?? item['address'] ?? '',
            'tel': item['telephone'] ?? '',
            'link': item['link'] ?? '',
          };
        }));

        if (searchResults.isEmpty) {
          print('검색 결과가 없습니다.');
        }
      } else {
        print('네이버 지도 API 호출 실패: ${response.body}');
        throw Exception('Failed to fetch cafes');
      }
    } catch (e) {
      print('카페 검색 중 오류 발생: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 선택된 카페 설정
  void setSelectedCafe(Map<String, dynamic> cafe) {
    selectedCafe = cafe;
    notifyListeners();
  }

  // HTML 태그 제거
  String _stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>');
    return htmlString.replaceAll(regex, '');
  }

  // Firebase에 카페 저장
  Future<void> saveCafeToFirebase(Map<String, dynamic> cafe) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('cafe').doc(cafe['name']);
      await docRef.set({
        'name': cafe['name'],
        'address': cafe['address'],
        'tel': cafe['tel'],
        'link': cafe['link'],
      });
      print('${cafe['name']} 저장 완료!');
    } catch (e) {
      print('Firebase 저장 중 오류 발생: $e');
    }
  }
}

