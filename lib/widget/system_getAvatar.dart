import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvatarService {
  static Future<Uint8List?> getUserAvatar(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (userDoc.exists && userDoc.data()?['avatar'] != null) {
        return base64Decode(userDoc['avatar']);
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'avatar : $e");
    }
    return null;
  }
}