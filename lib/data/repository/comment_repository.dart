import 'package:cloud_firestore/cloud_firestore.dart';

class CommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComment(String postId, String comment) async {
    await _firestore.collection('comments').add({
      'postId': postId,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
