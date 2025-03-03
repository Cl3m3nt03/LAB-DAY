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


// Si Vous voulez afficher l'avatar de l'utilisateur connecté, vous pouvez utiliser le code suivant dans votre fichier dart :

/* 
import 'package:makeitcode/services/avatar_service.dart';
import 'package:makeitcode/widget/auth.dart';

Future<void> _loadAvatar() async {
  String? uid = Auth().currentUser?.uid;
  if (uid != null) {
    Uint8List? avatar = await AvatarService.getUserAvatar(uid);
    setState(() {
      _avatarImage = avatar;
    });
  }
}
*/

// Vous pouvez ensuite afficher l'avatar de l'utilisateur dans votre application en utilisant le code suivant :
/*
  CircleAvatar(
    radius: 20,
    backgroundImage: _avatarImage != null
        ? MemoryImage(_avatarImage!)
        : AssetImage('assets/icons/logo.png')
            as ImageProvider,
  ),
*/