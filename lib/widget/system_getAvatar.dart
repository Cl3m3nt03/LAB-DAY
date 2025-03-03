import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for retrieving user avatars from Firestore.
class AvatarService {
  /// Fetches and decodes the user's avatar from Firestore.
  /// 
  /// - `uid`: The user ID.
  /// - Returns the avatar as `Uint8List` if available, otherwise `null`.

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