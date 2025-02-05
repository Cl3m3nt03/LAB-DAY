import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClassementPage extends StatelessWidget {
  final Stream<QuerySnapshot> _rankingStream = FirebaseFirestore.instance.collection('Users').orderBy('totalpoints', descending: true).snapshots();

  Future<String?> getCurrentUserPseudo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    return userDoc.exists ? userDoc['pseudo'] as String? : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentUserPseudo(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        String? currentUserPseudo = userSnapshot.data;

        return StreamBuilder<QuerySnapshot>(
          stream: _rankingStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: snapshot.data!.docs.asMap().entries.map((entry) {
                int rank = entry.key + 1;
                DocumentSnapshot document = entry.value;
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                return classementCard(
                  rank: rank,
                  name: data['pseudo'],
                  url: "debug-master",
                  points: data['totalpoints'].toString(),
                  isCurrentUser: data['pseudo'] == currentUserPseudo,
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

Widget classementCard({required int rank, required String name, required String url, required String points, required bool isCurrentUser,}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: const Color(0xFF5E4F73).withOpacity(0.85),
      borderRadius: BorderRadius.circular(12),
      border: rank <= 3 ? Border.all(color: Colors.amber, width: 2) : null,
    ),
    child: Row(
      children: [
        Text(
          "$rank.",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: rank <= 3 ? Colors.amber : Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/$url.jpg"),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isCurrentUser ? Color.fromARGB(255, 148, 199, 229) : Colors.white,
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
              const Text(
                "Voir le profil",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.star, size: 28, color: Color.fromARGB(255, 252, 175, 88)),
      ],
    ),
  );
}