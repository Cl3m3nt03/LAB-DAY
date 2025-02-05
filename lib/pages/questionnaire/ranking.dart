import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class RankingPage extends StatefulWidget {

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
  final Stream<QuerySnapshot> _rankingStream = FirebaseFirestore.instance.collection('Users').orderBy("totalpoints", descending: true ).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: const Color(0xFF0B162C),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 113, 152, 1),
        foregroundColor: Colors.white,
      ),
      body:Container(
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
                style:  GoogleFonts.montserrat(textStyle:TextStyle(
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
          int rank = 1; 
          for (int i=1 ;  i<=20 ; i++){
            rank+=1; 
          }
          return Column(
            children: snapshot.data!.docs.asMap().entries.map((entry) {
            int rank = entry.key + 1; // Numérotation des rangs
            DocumentSnapshot document = entry.value;
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return classementCard(rank: rank, name: data['pseudo'], url: "debug-master", points: data['totalpoints'].toString());
            }).toList(),
          );
        },
      ), /*
            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  classementCard(rank: 1, name: "Maître du Debug", url: "debug-master", points: "2500"),
                  classementCard(rank: 2, name: "Hacker Nocturne", url: "night-hacker", points: "2300"),
                  classementCard(rank: 3, name: "Bug Slayer", url: "bug-slayer", points: "2200"),
                  classementCard(rank: 4, name: "Compilateur Humain", url: "human-compiler", points: "2100"),
                  classementCard(rank: 5, name: "Code Alchimiste", url: "code-alchemist", points: "2000"),
                  classementCard(rank: 6, name: "Architecte du Cloud", url: "cloud-architect", points: "1950"),
                  classementCard(rank: 7, name: "Guru des Algorithmes", url: "algo-guru", points: "1900"),
                  classementCard(rank: 8, name: "Samouraï du Terminal", url: "terminal-samurai", points: "1850"),
                ],
              ),
            ),*/
          ],
        ),
      ),

      ),
    );
  }
}

Widget classementCard({required int rank, required String name, required String url, required String points}) {
  

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
          style: GoogleFonts.montserrat(textStyle:TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: rank <= 3 ? Colors.amber : Colors.white,
          ),
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
                  color: name == "Hacker Nocturne" ? Color.fromARGB(255, 148, 199, 229) : Colors.white,
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
              Text(
                "Voir le profil",
                style: const TextStyle(
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
