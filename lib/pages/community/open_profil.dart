import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OpenProfilePage extends StatefulWidget {
  final String uid;

  OpenProfilePage({required this.uid});

  @override
  _OpenProfilePageState createState() => _OpenProfilePageState();
}

class _OpenProfilePageState extends State<OpenProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String bio = '';
  String name = '';
  int level = 0;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void didUpdateWidget(covariant OpenProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      // Si l'UID a changé, récupérer le nouveau profil
      getProfile();
    }
  }

  Future<void> getProfile() async {
    setState(() {
      // Réinitialisation pour éviter d'afficher de vieilles données
      bio = '';
      name = '';
      level = 0;
    });

    try {
      final doc = await _firestore.collection('Users').doc(widget.uid).get();
      if (doc.exists) {
        setState(() {
          name = doc.data()?['pseudo'] ?? '';
          bio = doc.data()?['bio'] ?? '';
          level = doc.data()?['curentlevel'] ?? 0; // Correction de la valeur par défaut
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.isNotEmpty ? name : 'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              bio.isNotEmpty ? bio : 'No bio available.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Level: $level',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(widget.uid),
          ],
        ),
      ),
    );
  }
}
