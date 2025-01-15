import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:makeitcode/widget/toastMessage.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  String? errormessage = '';
  bool itserrormessage = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController pseudoController = TextEditingController();
  final AutoScrollController _scrollController = AutoScrollController();
        


  final ToastMessage toast = ToastMessage();

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

  bool _validateFields() {
    if (pseudoController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        errormessage = 'Tous les champs doivent être remplis';
        itserrormessage = true;
      });
      return false;
    }

    if (!emailController.text.contains('@')) {
      setState(() {
        errormessage = 'Adresse email invalide';
        itserrormessage = true;
      });
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errormessage = 'Les mots de passe ne correspondent pas';
        itserrormessage = true;
      });
      return false;
    }

    return true;
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!_validateFields()) {
      toast.showToast(context,errormessage ?? 'Erreur inconnue', isError: true);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
     
      User? user = Auth().currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      }
      

      CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');
      await usersRef.doc(Auth().currentUser?.uid).set({
        'uid': Auth().currentUser?.uid,
        'email': emailController.text,
        'pseudo': pseudoController.text,
      });

      toast.showToast(context,'Compte créé avec succès');
      _resetFields();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      toast.showToast(context,'Erreur : ${e.message}', isError: true);
    } catch (e) {
      toast.showToast(context,'Une erreur est survenue : $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetFields() {
    pseudoController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }


  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextButton(
        style: TextButton.styleFrom(
          shadowColor: Colors.black,
          elevation: 5,
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: Color.fromARGB(249, 161, 119, 51),
        ),
        onPressed: () async {
          await createUserWithEmailAndPassword();
        },
        child: const Text(
          'INSCRIPTION',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
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
      child: const Icon(
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
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(0, 113, 152, 1), Color.fromARGB(255, 11, 22, 44)],
                stops: [0.2, 0.9],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              return SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0,
                ),
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
                            EntryField(
                              height: 20,
                              title: 'Pseudo',
                              controller: pseudoController,
                              prefixIcons: Icons.person,
                            ),
                            const SizedBox(height: 20),
                            EntryField(
                              height: 20,
                              title: 'Email',
                              controller: emailController,
                              prefixIcons: Icons.email,
                            ),
                            const SizedBox(height: 20),
                            EntryField(
                              height: 20,
                              title: 'Mot de passe',
                              controller: passwordController,
                              prefixIcons: Icons.lock,
                            ),
                            const SizedBox(height: 20),
                            EntryField(
                              height: 20,
                              title: 'Confirmer le mot de passe',
                              controller: confirmPasswordController,
                              prefixIcons: Icons.lock,
                            ),
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
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
