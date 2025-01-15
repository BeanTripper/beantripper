import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reportComment(
      String feedId, String commentId, String reason) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('reports').add({
      'feedId': feedId,
      'commentId': commentId,
      'reason': reason,
      'reporterId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> reportPost(String feedId, String reason) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('reports').add({
      'feedId': feedId,
      'reason': reason,
      'reporterId': user.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
