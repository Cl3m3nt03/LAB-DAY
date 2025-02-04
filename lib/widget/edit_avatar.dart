import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makeitcode/widget/auth.dart';

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

class EditAvatar extends StatefulWidget {
  final Function(File?, String?) onImageSelected;

  const EditAvatar({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  State<EditAvatar> createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  File? _selectedImage;
  String? base64String;
  Uint8List? _avatarImage;
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
