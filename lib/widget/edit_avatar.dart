import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makeitcode/widget/auth.dart';

/// A function to retrieve the user's avatar from Firestore and decode it into a byte array.
Future<Uint8List?> getUserAvatar(String uid) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userDoc.exists) {
      return base64Decode(userDoc['avatar']);
    }
  } catch (e) {
    print("Erreur lors de la récupération de l'avatar : $e");
  }
  return null;
}

/// A widget for selecting and editing a user's avatar.
class EditAvatar extends StatefulWidget {
  final Function(File?, String?) onImageSelected;

  const EditAvatar({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  State<EditAvatar> createState() => _EditAvatarState();
}

/// The state class for managing the avatar editing logic.
class _EditAvatarState extends State<EditAvatar> {
  File? _selectedImage;
  String? base64String;
  Uint8List? _avatarImage;

  /// Picks an image from the gallery and encodes it into a base64 string.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      List<int> imageBytes = _selectedImage!.readAsBytesSync();
      base64String = base64Encode(imageBytes);
      debugPrint(base64String);
      widget.onImageSelected(_selectedImage, base64String);
    }
  }
  /// Requests permission to access photos if not already granted.
  Future<void> _requestPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      await Permission.photos.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }
  /// Loads the user's avatar from Firestore if available.
  Future<void> _loadAvatar() async {
    String? uid = Auth().currentUser?.uid;
    if (uid != null) {
      Uint8List? avatar = await getUserAvatar(uid);
      setState(() {
        _avatarImage = avatar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _avatarImage != null
            ? MemoryImage(_avatarImage!)
            : AssetImage('assets/icons/logo.png') as ImageProvider,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
