import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedWriteViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  final List<File> selectedImages = [];
  final List<String> categories = [];
  String cafeName = '';
  String content = '';

  void setCafeName(String value) {
    cafeName = value;
    notifyListeners();
  }

  void setPostContent(String value) {
    content = value;
    notifyListeners();
  }

  void toggleTagSelection(String tag, BuildContext context) {
    if (categories.contains(tag)) {
      categories.remove(tag);
    } else if (categories.length < 3) {
      categories.add(tag);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('태그는 최대 3개까지 선택 가능합니다.')),
      );
    }
    notifyListeners();
  }

  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();
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

  Future<void> uploadDataToFirebase(String userName) async {
    if (cafeName.isEmpty || content.isEmpty || categories.isEmpty) {
      throw Exception('모든 필드를 입력해야 합니다.');
    }

    try {
      final storageRef = FirebaseStorage.instance.ref();
      final firestore = FirebaseFirestore.instance;

      // 이미지 업로드
      List<String> imageUrls = [];
      for (var file in selectedImages) {
        final imageRef =
            storageRef.child('uploads/${file.path.split('/').last}');
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
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Firebase 업로드 중 오류 발생: $e');
      rethrow;
    }
  }
}

final feedWriteViewModelProvider = ChangeNotifierProvider((ref) {
  final viewModel = FeedWriteViewModel();
  return viewModel;
});
