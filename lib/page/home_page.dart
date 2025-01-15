import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/widget/navBar.dart';


String checkEmailVerification(emailVerified) {
  User? user = FirebaseAuth.instance.currentUser;
  final String emailVerified;

  if (user != null) {
    if (user.emailVerified) {
      emailVerified = 'Email vérifié';
    } else {
      emailVerified = 'Email non vérifié';
    }
  } else {
    emailVerified = 'Aucun utilisateur connecté';
  }
  return emailVerified;
}



class HomePage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    String emailVerified = '';
    emailVerified = checkEmailVerification(emailVerified);
    return Scaffold(
      body:Stack(
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
      ),
          Column(
          children: [
            Text(Auth().currentUser?.email ?? 'No email available', style: TextStyle(color: Colors.white),),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.white,
              onPressed: () {
                Auth().signOut();
              },
            ),
            Text(Auth().currentUser?.email ?? 'No email available', style: TextStyle(color: Colors.white),),
            Text(Auth().currentUser?.displayName ?? 'No uid available', style: TextStyle(color: Colors.white),),

            
          ],
        ),
        ],
      ),
    );
  }
}

