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
  bool isPasswordVisible = true;

    @override
  Widget build(BuildContext context) {
    // Background gradient container
    return Scaffold(
      appBar: AppBar(
        title:Text(
          'Sécurité',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
              child:
              Container(
                height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
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
                // 
                child: Column(
                  children: [
                      Divider(
                      thickness: 1.5,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    UpdatePasswordWidget(),
                  ],
                ),
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
  final TextEditingController confirmPasswordController =TextEditingController();

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
      child : SingleChildScrollView(
      child: Column(
        children: [
          EntryField(
            controller: lastPasswordController,
            title: 'Ancien Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          EntryField(
            controller: newPasswordController,
            title: 'Nouveau Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
          EntryField(
            controller: confirmPasswordController,
            title: 'Confirmer le Mot de Passe',
            prefixIcons: Icons.lock,
            height: 20,
          ),

     
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
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
            backgroundColor: Color.fromARGB(249, 153, 120, 67),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Modifier son mot de passe',
               style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 14,color: Colors.white),),                      
            ),
          ),
        ],
      ),
      ), 
    );
  }
}
