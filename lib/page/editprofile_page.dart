import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/page/profile_page.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getUserPseudo(String uid) async {
  final userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  if (userDoc.exists) {
    return userDoc.data()?['pseudo'] ?? 'No pseudo found';
  }
  return 'No pseudo found';
}

class EditCompte extends StatelessWidget {
  EditCompte({super.key});

  final TextEditingController EditPrenomController = TextEditingController();
  final TextEditingController EditNomController = TextEditingController();
  final TextEditingController EditNumberController = TextEditingController();
  final TextEditingController EditBioController = TextEditingController();
  final TextEditingController EditPseudoController = TextEditingController();
  final TextEditingController EditEmailController = TextEditingController();

  // Fonction pour mettre à jour la bio de l'utilisateur dans Firestore
  Future<void> updateUserBio(String uid) async {
    try {
      print('updateUserBio called with uid: $uid');
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'bio': EditBioController.text,
        });
        print('Bio updated successfully');
      } else {
        print('Document utilisateur non trouvé');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la bio: $e');
    }
  }

  // Fonction pour mettre à jour le pseudo de l'utilisateur dans Firestore
  Future<void> updateUserPseudo(String uid) async {
    try {
      print('updateUserPseudo called with uid: $uid');
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'pseudo': EditPseudoController.text,
        });
        print('Pseudo updated successfully');
      } else {
        print('Document utilisateur non trouvé');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du pseudo: $e');
    }
  }

  // Fonction pour mettre à jour l'email de l'utilisateur dans Firestore
  Future<void> updateUserEmail(String uid) async {
    try {
      print('updateUserEmail called with uid: $uid');
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'email': EditEmailController.text,
        });
        print('Email updated successfully');
      } else {
        print('Document utilisateur non trouvé');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 113, 152, 1),
                    Color.fromARGB(255, 11, 22, 44),
                  ],
                  stops: [0.1, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: const Color.fromRGBO(24, 37, 63, 0.4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Modifier Profil",
                                    style: TextStyle(
                                      color: Color.fromARGB(250, 175, 142, 88),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: MediaQuery.of(context).size.width / 2 - 65,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/icons/baka.png'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          EntryField(
                            title: 'Pseudo',
                            controller: EditPseudoController,
                            prefixIcons: Icons.person,
                            height: 20,
                          ),
                          SizedBox(height: 20),
                          EntryField(
                            title: 'Email',
                            controller: EditEmailController,
                            prefixIcons: Icons.person,
                            height: 20,
                          ),
                          SizedBox(height: 20),
                          EntryField(
                            title: 'Bio',
                            controller: EditBioController,
                            prefixIcons: Icons.question_answer,
                            height: 60,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final String uid =
                                  FirebaseAuth.instance.currentUser?.uid ?? '';

                              if (EditBioController.text.isNotEmpty) {
                                await updateUserBio(uid);
                              }
                              if (EditPseudoController.text.isNotEmpty) {
                                await updateUserPseudo(uid);
                              }
                              if (EditEmailController.text.isNotEmpty) {
                                await updateUserEmail(uid);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(250, 175, 142, 88),
                            ),
                            child: Text(
                              "Enregistrer les modifications",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
