import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String feedId, String content) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await _firestore
          .collection('feed')
          .doc(feedId)
          .collection('comments')
          .add({
        'content': content,
        'userId': user.uid,
        'userName': user.displayName ?? '익명',
        'createdAt': FieldValue.serverTimestamp(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(String feedId) async {
    final snapshot = await _firestore
        .collection('feed')
        .doc(feedId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
