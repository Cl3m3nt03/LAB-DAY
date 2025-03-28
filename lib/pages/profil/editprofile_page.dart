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
import 'package:makeitcode/theme/custom_colors.dart';


Future<String> getUserPseudo(String uid) async {
  final userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  if (userDoc.exists) {
    return userDoc.data()?['pseudo'] ?? 'No pseudo found';
  }
  return 'No pseudo found';
}

class EditCompte extends StatelessWidget {
  CustomColors? customColor;

  EditCompte({super.key});

  final TextEditingController EditPrenomController = TextEditingController();
  final TextEditingController EditNomController = TextEditingController();
  final TextEditingController EditNumberController = TextEditingController();
  final TextEditingController EditBioController = TextEditingController();
  final TextEditingController EditPseudoController = TextEditingController();
  final TextEditingController EditEmailController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
final FocusNode _focusNodePrenom = FocusNode();
final FocusNode _focusNodeNom = FocusNode();
final FocusNode _focusNodeNumber = FocusNode();
final FocusNode _focusNodeBio = FocusNode();
final FocusNode _focusNodePseudo = FocusNode();
final FocusNode _focusNodeEmail = FocusNode();


  // Function to update the user's bio in Firestore
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

  // Function to update the user's pseudo in Firestore
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

  // Function to update the user's email in Firestore
  Future<void> updateUserEmail(String newEmail, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("Aucun utilisateur connecté.");
        return;
      }

      // Retrieve the authentication provider
      String providerId = user.providerData[0].providerId;

      // Reauthentication required before updating email
      if (providerId == "password") {
        // The user registered with email/password
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

      // Update email in Firebase Auth
      await user.updateEmail(newEmail);
      print("Email mis à jour dans Firebase Auth.");

      // Update email in Firestore
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

  // Function to update the user's avatar in Firestore
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
    customColor = Theme.of(context).extension<CustomColors>();
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
        appBar: AppBar(
        title:Text(
          'Informations',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: customColor?.white ??Colors.white),
          ),
        ),
        backgroundColor: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: customColor?. white ??Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              child :Container(
                height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),
                      customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
                    ],
                    stops: [0.1, 0.9],
                    center: Alignment(-0.7, 0.7),
                    radius: 0.8,
                  ),
                ),
              child: SingleChildScrollView(

                child: Column(
                  children: [
                     Divider(
                      thickness: 1.5,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        Positioned(
                          bottom: -50,
                          left: MediaQuery.of(context).size.width / 2 - 65,
                          child: EditAvatar(onImageSelected: _onAvatarSelected),
                        ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child:
                      Column(
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
                         
                            if (_base64Avatar != null) {
                              await updateUserAvatar(uid, _base64Avatar);
                            } else {
                              print('No avatar selected');
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditCompte()),
                            );
                          },
                            style: ElevatedButton.styleFrom(
                            backgroundColor: customColor?. vibrantBlue ?? Color.fromARGB(249, 153, 120, 67),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                        ),
                            ),
                            child: Text(
                              "Enregistrer les modifications",
                               style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 13,color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ); 
  }
}
