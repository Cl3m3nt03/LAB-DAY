import 'package:flutter/material.dart';

Future<void> showPasswordDialog(
    BuildContext context, Function(String) onPasswordEntered) async {
  TextEditingController passwordController = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(197, 51, 53, 196),
        title: Text("Confirmer votre identité",
            style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Veuillez entrer votre mot de passe pour continuer",
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler",
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
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
                style:
                    TextStyle(color: const Color.fromARGB(255, 255, 255, 255))),
          ),
        ],
      );
    },
  );
}
