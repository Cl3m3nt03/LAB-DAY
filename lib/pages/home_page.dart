import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:makeitcode/widget/project_card.dart';
import 'package:makeitcode/pages/projects/projects_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  void fetchPseudo() {}
  void getLevel() {}
}

class _HomePageState extends State<HomePage> {
  String emailVerified = '';
  String pseudo = '';
  int lvl = 0;
  int xp = 90;
  int objXp = 100;


  final Stream<QuerySnapshot> _projectsStreamBegan = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'began')
      .snapshots();
  final Stream<QuerySnapshot> _projectsStreamUnlocked = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'unlocked')
      .snapshots();

  @override
  void initState() {
    super.initState();
    getLevel();
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

Future<void> getLevel() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      print(userDoc.data()?['currentLvl']);
      if (userDoc.exists) {
        setState(() {
          lvl = userDoc.data()?['currentLvl'] ?? 0; 
          xp = userDoc.data()?['currentXp'] ?? 0; 
          objXp = userDoc.data()?['objectiveXp'] ?? 100; 
        });
      } else {
        print('Le document utilisateur n\'existe pas');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }
}



  getlvlRank(int level){
    if(level >= 0 || level <= 5){
      return 'DEBUTANT';
    }
    return 'NOVICE';
  }

  getlvlBadge(int level){
    String path = 'assets/icons/';
    if(level >= 0 || level <= 5){
      return '${path}BronzeIcon.png';
    }
    return '${path}BronzeIcon.png';
  }


Widget _title(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width *0.6 ,
        child: Text(
          'Salut, $pseudo 👋',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.clip
            )
          ),
        )

        ),
        SizedBox(height: 5,),
        Text(
          "Code en t'amusant",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400
            )
          )
        )
    ],
  );
}


Widget _profilePicture(){
  return CircleAvatar(
    backgroundImage: AssetImage('assets/icons/baka.png'),
    radius: 45,

  );
}
Widget _playerLevel(){
  return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff0692C2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff0692C2).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), 
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
                  Text(
                    getlvlRank(lvl),
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                      )
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Color(0xffE6E6E6).withOpacity(0.64),
                        borderRadius:  BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), 
                          ),
                        ],
                    ),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Niv. ',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5), 
                                  fontWeight: FontWeight.normal, 
                                  fontSize: 16, 
                                ),
                              ),
                              TextSpan(
                                text: '$lvl', 
                                style: GoogleFonts.montserrat(textStyle:  TextStyle(
                                  color: Colors.black, 
                                  fontWeight: FontWeight.w800, 
                                  fontSize: 17, 
                                ),
                              ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5,),
                        Image(
                          image: AssetImage(getlvlBadge(lvl)),
                          height: 25,
                        )
                      ],
                    )
                  )
            ],
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 25,
            child: Progressbar(percentageCompletion: (xp/objXp)*100, showPercentage:  false),
          ),
          Row(
            children: [
              Text(
                "$xp xp",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Spacer(),
              Text(
                "$objXp xp",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ],
          ),
        ],
      ),
  );
}
Widget _projects(stream){
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Une erreur est survenue',
                style: TextStyle(color: Colors.red),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text(
                'Aucun projet trouvé.',
                style: TextStyle(color: Colors.white),
              );
            }

            return Center(
              child: Wrap(
                spacing: 30,
                runSpacing: 30,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> projet = document.data()! as Map<String, dynamic>;

                    return ProjectCard(projet: projet);
                }).toList(),
              ),
            );
          },
        ),
      ],
    ),
  );
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
            child: SingleChildScrollView(
            child: 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        _title(),
                        Spacer(),
                        _profilePicture()
                      ],
                    ),
                    SizedBox(height: 50,),
                    _playerLevel(),
                    SizedBox(height: 25,),
                    Row(
                      children: [
                        Text(
                          'LES PROJETS',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 27
                            )
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectsPage(),
                              ),
                            );
                          }, 
                          child: Text(
                            'Tout voir',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Color(0xffC6C6C6)
                              )
                            ),
                          ))
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: 
                        Row(
                          children: [
                          _projects(_projectsStreamBegan),
                          SizedBox(width: 30,),
                          _projects(_projectsStreamUnlocked)
                          ],
                        ),
                    )
                ],
              ),
            ),
           ),
          ),
        ],
      ),
    );
  }
}
