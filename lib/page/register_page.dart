import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:makeitcode/page/home_page.dart';
import 'package:makeitcode/widget/tree.dart';
import 'package:makeitcode/widget/textField.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  String? errormessage = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();
  final AutoScrollController _scrollController = AutoScrollController();

  final FocusNode pseudoFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    pseudoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    pseudoFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }



  Future<void> createUserWithEmailAndPassword() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty || pseudoController.text.isEmpty) {
      setState(() {
        errormessage = 'Tous les champs doivent être remplis';
      });
      print('Erreur: Tous les champs doivent être remplis');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errormessage = 'Les mots de passe ne correspondent pas';
      });
      print('Erreur: Les mots de passe ne correspondent pas');
      return;
    }

    try {
      print('Tentative de création de compte...');
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('Compte créé avec succès');
      await Auth().signInWhithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print('Connexion réussie');

      CollectionReference pseudoRef = 
      FirebaseFirestore.instance
      .collection('Users')
      .doc(Auth().currentUser?.uid)
      .collection('Informations Utilisateur');
      await pseudoRef.add({
        'uid': Auth().currentUser?.uid,
        'email': emailController.text,
        'pseudo': pseudoController.text,
       }
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      setState(() {
        errormessage = 'Une erreur s\'est produite';
      });
      print('Erreur: $e');
    }
  }

  void _scrollToIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 300));
    _scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

 

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Builder(
        builder: (context) => TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            backgroundColor: const Color.fromRGBO(95, 194, 186, 1),
          ),
          onPressed: ()  {
             createUserWithEmailAndPassword();
          },
          child: Text(
            'INSCRIPTION',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      "Créer votre compte",
      style: TextStyle(
        color: Colors.white,
        fontSize: 31,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
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
          ),
          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _backButton(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: _title(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Column(
                          children: [
                            EntryField(title: 'Pseudo',controller: pseudoController,prefixIcons: Icons.person,),
                            const SizedBox(height: 20),
                            EntryField(title: 'Email',controller: emailController,prefixIcons: Icons.email,),
                            const SizedBox(height: 20),
                            EntryField(title: 'Mot de passe',controller: passwordController,prefixIcons: Icons.lock,),
                            const SizedBox(height: 20),
                            EntryField(title: 'Confirmer le mot de passe',controller: confirmPasswordController,prefixIcons: Icons.lock,),
                            const SizedBox(height: 20),
                            _submitButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}