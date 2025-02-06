import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/pages/profil/open_profil.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/system_getAvatar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _Classement();
  }
}

class _Classement extends State<RankingPage> {
  void onButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassementPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onButtonPressed,
        tooltip: 'Classement',
        child: const Icon(Icons.emoji_events),
      ),
    );
  }
}
class ClassementPage extends StatelessWidget {
  final Stream<QuerySnapshot> _rankingStream = FirebaseFirestore.instance
      .collection('Users')
      .orderBy("totalpoints", descending: true)
      .snapshots();

  Future<String?> getCurrentUserPseudo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      return userDoc['pseudo'];
    }
    return null;
  }

  Future<Uint8List?> getAvatarForUser(String uid) async {
    // Charger l'avatar de l'utilisateur ici
    return AvatarService.getUserAvatar(uid);
  }

  Future<String> getCurrentUid() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 113, 152, 1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(0, 113, 152, 1), Color.fromARGB(255, 11, 22, 44)],
            stops: [0.2, 0.9],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  "LES MEILLEURS CODEURS",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _rankingStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return FutureBuilder<String?>(
                    future: getCurrentUserPseudo(),
                    builder: (BuildContext context, AsyncSnapshot<String?> userPseudoSnapshot) {
                      if (userPseudoSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      String? currentUserPseudo = userPseudoSnapshot.data;

                      return Column(
                        children: snapshot.data!.docs.asMap().entries.map((entry) {
                          int rank = entry.key + 1;
                          DocumentSnapshot document = entry.value;
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          String playerPseudo = data['pseudo'];
                          String playerUid = document.id; // Assuming UID is stored as the document ID
                          Color textColor = playerPseudo == currentUserPseudo
                              ? const Color.fromARGB(255, 141, 227, 255)
                              : Colors.white;

                          // Utiliser un FutureBuilder pour charger l'avatar de manière indépendante
                          return FutureBuilder<Uint8List?>(
                            future: getAvatarForUser(playerUid),
                            builder: (BuildContext context, AsyncSnapshot<Uint8List?> avatarSnapshot) {
                              if (avatarSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              Uint8List? avatarImage = avatarSnapshot.data;

                              return classementCard(
                                rank: rank,
                                name: playerPseudo,
                                url: "debug-master", // Replace with the correct avatar URL
                                points: data['totalpoints'].toString(),
                                textColor: textColor,
                                avatarImage: avatarImage,  // Pass avatar image to the card
                                context: context,
                                playerUid: playerUid, // Pass player UID to the card
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget classementCard({
  required int rank,
  required String name,
  required String url,
  required String points,
  required Color textColor,
  required Uint8List? avatarImage,
  required BuildContext context, 
  required String playerUid, // UID ajouté ici
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: const Color(0xFF5E4F73).withOpacity(0.85),
      borderRadius: BorderRadius.circular(12),
      border: rank <= 3 ? Border.all(color: Colors.amber, width: 2) : null,
    ),
    
    child: Row(
      children: [
        Text(
          "$rank.",
          style: GoogleFonts.montserrat(textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: rank <= 3 ? Colors.amber : Colors.white,
          )),
        ),
        const SizedBox(width: 10 ,),
        CircleAvatar(
          radius: 28,
          backgroundImage: avatarImage != null
              ? MemoryImage(avatarImage)
              : const AssetImage("assets/splashscreen/icon.png") as ImageProvider,
        ),
        const SizedBox(width: 15,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "$points points",
                style: const TextStyle(
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5,),
              TextButton(
                style: TextButton.styleFrom(
                //backgroundColor: const Color.fromARGB(255, 243, 33, 229),
                padding: EdgeInsets.zero,
                minimumSize: Size.zero, // Supprime la taille minimale
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Réduit la marge
                
  
              ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenProfilePage(uid: playerUid), // Passer l'uid au constructeur
                    ),
                  );
                },
                child : Text(
                  "Voir le profil", 
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.star, size: 28, color: Color.fromARGB(255, 252, 175, 88)),
      ],
    ),
  );
}
