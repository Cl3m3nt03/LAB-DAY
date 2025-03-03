import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A function to show a dialog asking for the user's password to confirm identity.
Future<void> showPasswordDialog(
    BuildContext context, Function(String) onPasswordEntered) async {
  TextEditingController passwordController = TextEditingController();

  return showDialog(
    context: context,
    /// Displays the dialog to input the password and invokes the callback upon validation.
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(197, 51, 53, 196),
        title: Text("Confirmer votre identité",
                style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Veuillez entrer votre mot de passe pour continuer",
                style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.w500,overflow: TextOverflow.clip,fontSize: 15,color: Colors.white),),),
            /// The text input for the password is obscured, with a label for clarity.
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Mot de passe",
                  labelStyle: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255))),
            ),
          ],
        ),
        actions: [
          /// The dialog buttons for cancelling or validating the password entry.
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler",
             style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 14,color: Colors.white),),),

          ),
          TextButton(
            onPressed: () {
              //On envoie passwordController à notre fonction updatemail
              String password = passwordController.text;
              if (password.isNotEmpty) {
                onPasswordEntered(password);
                Navigator.of(context).pop();
              }
            },
            child: Text("Valider",
            style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 14,color: Colors.white),),),
          ),
        ],
      );
    },
  );
}
