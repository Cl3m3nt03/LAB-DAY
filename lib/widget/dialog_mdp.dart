import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/textField.dart';

Future<void> showPasswordDialog(
    BuildContext context, Function(String) onPasswordEntered) async {
  TextEditingController passwordController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color.fromRGBO(0, 113, 152, 0.9),
        shadowColor: Color.fromRGBO(2, 163, 217, 0.898),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          
          children: [
            Center(
              child: Image.asset(
                "assets/icons/Lock.png",
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Confirme ton identité",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Veuillez entrer votre mot de passe pour continuer",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            EntryField(
              title: 'Confirmation ',
              controller: passwordController,
              prefixIcons: Icons.lock,
              height: 20,
            ),
          ],
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  onPasswordEntered(passwordController.text);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Valider',
                  style: GoogleFonts.roboto(color: Colors.white , fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}