import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/pages/profil/profile_page.dart';
import 'package:makeitcode/widget/dialog_mdp.dart';
import 'package:makeitcode/widget/edit_avatar.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

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
  Future<void> updateUserEmail(String newEmail, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("Aucun utilisateur connecté.");
        return;
      }

      // Récupérer le fournisseur d'authentification
      String providerId = user.providerData[0].providerId;

      // Réauthentification requise avant la mise à jour de l'email
      if (providerId == "password") {
        // L'utilisateur s'est inscrit avec email/mot de passe
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        print("Réauthentification réussie avec le mot de passe.");
      } else if (providerId == "google.com") {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          print("L'utilisateur a annulé la connexion Google.");
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
        print("Réauthentification réussie avec Google.");
      } else {
        print("Fournisseur d'authentification non géré : $providerId");
        return;
      }

      // Mise à jour de l'email dans Firebase Auth
      await user.updateEmail(newEmail);
      print("Email mis à jour dans Firebase Auth.");

      // Mise à jour de l'email dans Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'email': newEmail,
      });

      print("Email mis à jour avec succès dans Firestore.");
    } catch (e) {
      print("Erreur lors de la mise à jour de l'email : $e");
    }
  }

  // Fonction pour mettre à jour l'avatar de l'utilisateur dans Firestore
  Future<void> updateUserAvatar(String uid, String? base64Avatar) async {
    try {
      print('updateUserAvatar called with uid: $uid');
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        if (base64Avatar != null) {
          await FirebaseFirestore.instance.collection('Users').doc(uid).update({
            'avatar': base64Avatar,
          });
          print('Avatar updated successfully');
        } else {
          print('No avatar to update');
        }
      } else {
        print('Document utilisateur non trouvé');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'avatar: $e');
    }
  }

  File? _selectedAvatar;
  String? _base64Avatar;

  void _onAvatarSelected(File? image, String? base64String) {
    _selectedAvatar = image;
    _base64Avatar = base64String;
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
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromRGBO(0, 113, 152, 1),
                      Color.fromARGB(255, 11, 22, 44),
                    ],
                    stops: [0.1, 0.9],
                    center: Alignment(-0.7, 0.7),
                    radius: 0.8,
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
                                    style: GoogleFonts.montserrat(textStyle:TextStyle(
                                      color: Color.fromARGB(250, 175, 142, 88),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          child: EditAvatar(onImageSelected: _onAvatarSelected),
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
                                showPasswordDialog(context, (String password) {
                                  updateUserEmail(
                                      EditEmailController.text, password);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(250, 175, 142, 88),
                            ),
                            child: Text(
                              "Enregistrer les modifications",
                               style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 13,color: Colors.white),),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final String uid =
                                  FirebaseAuth.instance.currentUser?.uid ?? '';
                              if (_base64Avatar != null) {
                                await updateUserAvatar(uid, _base64Avatar);
                              } else {
                                print('No avatar selected');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(250, 175, 142, 88),
                            ),
                            child: Text(
                              "Enregistrer l'avatar",
                                style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 13,color: Colors.white),),                      
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
