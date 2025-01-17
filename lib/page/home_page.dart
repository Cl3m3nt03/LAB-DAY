import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/auth.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  void fetchPseudo() {}
}

class _HomePageState extends State<HomePage> {
  String emailVerified = '';
  String pseudo = '';

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
    fetchPseudo();
  }

Future<void> fetchPseudo() async {
  try {
    String? fetchedPseudo = await Auth().recoveryPseudo();
    if (mounted) { 
      setState(() {
        pseudo = fetchedPseudo ?? 'Pseudo non disponible';
      });
    }
  } catch (e) {
    print('Erreur lors de la récupération du pseudo : $e');
    if (mounted) {
      setState(() {
        pseudo = 'Pseudo non disponible';
      });
    }
  }
}

  void checkEmailVerification() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        emailVerified = user.emailVerified ? 'Email vérifié' : 'Email non vérifié';
      });
    } else {
      setState(() {
        emailVerified = 'Aucun utilisateur connecté';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email display
                  Text(
                    currentUser?.email ?? 'Aucun email disponible',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  // Email verification status
                  Text(
                    emailVerified,
                    style: TextStyle(
                      color: emailVerified == 'Email vérifié'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display name or UID
                  Text(
                     'UID : ${currentUser?.uid ?? 'Non disponible'}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                      Text(
                      'Name : ${currentUser?.displayName ?? 'Non disponible'}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Pseudo
                  Text(
                    'Pseudo : $pseudo',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Spacer(),
                  // Logout button
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text('Se déconnecter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () async {
                        await Auth().signOut();

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
