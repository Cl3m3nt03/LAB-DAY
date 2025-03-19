import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/theme/custom_colors.dart';

// This is the registration page where users can create an account
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// State class for managing the registration form state
class _RegisterPageState extends State<RegisterPage> {
  CustomColors? customColor;

  // State variables for managing password visibility, form validation, and loading state
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

  // Dispose the controllers when the page is destroyed to avoid memory leaks
  @override
  void dispose() {
    pseudoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
  // Validates the input fields (checks for empty fields, valid email, and matching passwords)
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
  
  // Handles user registration via Firebase Authentication and sends email verification
  Future<void> createUserWithEmailAndPassword() async {
    if (!_validateFields()) {
      toast.showToast(context, errormessage ?? 'Erreur inconnue', isError: true);
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

      Auth().initializeUser(
        email: emailController.text,
        username: pseudoController.text,
      );

      toast.showToast(context, 'Compte créé avec succès');
      _resetFields();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      toast.showToast(context, 'Erreur : ${e.message}', isError: true);
    } catch (e) {
      toast.showToast(context, 'Une erreur est survenue : $e', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Clears all the input fields after successful registration
  void _resetFields() {
    pseudoController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // Button widget that triggers user registration when pressed
  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadowColor: customColor?.dark ?? Colors.black,
          elevation: 5,
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: customColor?.burntCaramel ?? Color.fromARGB(249, 161, 119, 51),
        ),
        onPressed: () async {
          await createUserWithEmailAndPassword();
        },
        child:  Text(
          'INSCRIPTION',
            style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),)
        ),
      ),
    );
  }
  
  // Title widget displaying the page header
  Widget _title() {
    return  Text(
      "Créer votre compte",
        style:GoogleFonts.montserrat(textStyle: TextStyle(
        color: customColor?.white ??Colors.white, 
        fontSize: 29, 
        fontWeight: FontWeight.bold,     
      ),
        ),
    );
  }

  // Back button widget to navigate to the previous screen  
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child:  Icon(
        Icons.arrow_back_ios,
        color: customColor?.white ??Colors.white,
      ),
    );
  }

  // Builds the registration page UI
  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: [customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1), customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),],
                  stops: [0.2, 0.9],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            // Scrollable view for the registration form, allowing for keyboard interaction
            SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
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
            // Displays a loading spinner while registration is in progress

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
