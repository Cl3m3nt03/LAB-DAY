import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/auth.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:makeitcode/page/login_page.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isPasswordVisible = true;
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
      await Auth().createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
    }
  }

  void _scrollToIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 300));
    _scrollController.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
  }

  Widget _entryField(String title, TextEditingController controller, IconData prefixIcon, FocusNode focusNode, int index) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _scrollController,
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          obscureText: (title == 'Mot de passe' || title == 'Confirmation du mot de passe') ? isPasswordVisible : false,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: (title == 'Mot de passe' || title == 'Confirmation du mot de passe')
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: isPasswordVisible
                        ? Icon(CupertinoIcons.eye, color: Colors.white.withOpacity(0.5))
                        : Icon(CupertinoIcons.eye_slash, color: Colors.white.withOpacity(0.5)),
                  )
                : null,
            prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.5)),
            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            labelText: title,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            filled: true,
            fillColor: Color.fromRGBO(50, 50, 79, 1),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onTap: () {
            _scrollToIndex(index);
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: const Color.fromRGBO(95, 194, 186, 1),
        ),
        onPressed: () => createUserWithEmailAndPassword(),
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
    );
  }

  Widget _errorMessage() {
    return Text(
      errormessage == '' ? '' : 'Erreur: $errormessage',
      style: TextStyle(color: Colors.white),
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
                            _entryField('Pseudo', pseudoController, Icons.person, pseudoFocusNode, 0),
                            _entryField('Adresse email', emailController, Icons.mail, emailFocusNode, 1),
                            _entryField('Mot de passe', passwordController, Icons.lock, passwordFocusNode, 2),
                            _entryField('Confirmation du mot de passe', confirmPasswordController, Icons.lock, confirmPasswordFocusNode, 3),
                            const SizedBox(height: 20),
                            _submitButton(),
                            _errorMessage(),
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