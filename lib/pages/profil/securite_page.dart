import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget for password update page layout.
class SecuritePage extends StatefulWidget {
  const SecuritePage({super.key});

  @override
  _SecuritePageState createState() => _SecuritePageState();
}

class _SecuritePageState extends State<SecuritePage> {
  @override
  Widget build(BuildContext context) {
    // Background gradient container
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
                // Scrollable area for content
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 110,
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
                                    "Modifier Mot de Passe",
                                    style: GoogleFonts.montserrat(textStyle:TextStyle(
                                      color: Color.fromARGB(250, 175, 142, 88),
                                      fontSize: 20,
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
                      ],
                    ),
                    SizedBox(height: 120),
                    // Intégration de ton widget ici
                    UpdatePasswordWidget(),
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

class UpdatePasswordWidget extends StatefulWidget {
  @override
  _UpdatePasswordWidgetState createState() => _UpdatePasswordWidgetState();
}

class _UpdatePasswordWidgetState extends State<UpdatePasswordWidget> {
  final TextEditingController lastPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    lastPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          EntryField(
            controller: lastPasswordController,
            title: 'Ancien Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),
          SizedBox(height: 20),
          EntryField(
            controller: newPasswordController,
            title: 'Nouveau Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),
          SizedBox(height: 20),
          EntryField(
            controller: confirmPasswordController,
            title: 'Confirmer le Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              final oldPassword = lastPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              // Vérification des champs
              if (newPassword.isEmpty ||
                  confirmPassword.isEmpty ||
                  oldPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez remplir tous les champs.')),
                );
                return;
              }

              if (newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Les mots de passe ne correspondent pas.')),
                );
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser;

                final cred = EmailAuthProvider.credential(
                  email: user!.email!,
                  password: oldPassword,
                );

                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPassword);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Mot de passe mis à jour avec succès !')),
                );

                lastPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur : ${e.toString()}')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(250, 175, 142, 88),
            ),
            child: Text(
              'Confirmer',
               style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 14,color: Colors.white),),                      
            ),
          ),
        ],
      ),
    );
  }
}
