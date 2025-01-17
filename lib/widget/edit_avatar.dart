import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditAvatar extends StatefulWidget {
  final Function(File?, String?) onImageSelected;

  const EditAvatar({required this.onImageSelected, Key? key}) : super(key: key);

  @override
  State<EditAvatar> createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  File? _selectedImage;
  String? base64String;

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _selectedImage != null
            ? FileImage(_selectedImage!)
            : AssetImage('assets/icons/baka.png') as ImageProvider,
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
