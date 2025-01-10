import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(
      String feedId, String userId, String userName, String comment) async {
    await _firestore.collection('feed').doc(feedId).collection('comments').add({
      'userId': userId,
      'userName': userName,
      'content': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
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
