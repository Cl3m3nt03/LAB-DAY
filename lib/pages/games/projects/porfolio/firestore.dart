import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    await _db.collection('test').doc(userId).set(userData);
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot doc = await _db.collection('test').doc(userId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
}
