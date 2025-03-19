import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:makeitcode/widget/project_card.dart';
import 'package:makeitcode/pages/games/projects/projects_page.dart';
import 'package:makeitcode/widget/rewardScreen.dart';
import 'package:makeitcode/widget/system_getAvatar.dart';
import 'package:makeitcode/theme/custom_colors.dart';
/// The HomePage widget is the main screen of the app, displaying user information,
/// level progress, and ongoing projects.
class HomePage extends StatefulWidget {
  
  // Creates the state for HomePage.
  @override
  _HomePageState createState() => _HomePageState();
  // Fetches the pseudo for the user.
  void fetchPseudo() {}
  // Retrieves the user's level.
  void getLevel() {}
}

// State for HomePage, handles UI and data fetching
class _HomePageState extends State<HomePage> {
    CustomColors? customColor;




  String emailVerified = '';
  String pseudo = '';
  int lvl = 0;
  double xp = 90;
  double objXp = 100;
  Uint8List? _avatarImage;
  

Future<void> _loadAvatar() async {
  String? uid = Auth().currentUser?.uid;
  if (uid != null) {
    Uint8List? avatar = await AvatarService.getUserAvatar(uid);
    if (mounted) {
      setState(() {
        _avatarImage = avatar;
      });
    }
  }
}

  // Stream for projects that have begun.
  final Stream<QuerySnapshot> _projectsStreamBegan = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'began')
      .snapshots();

  // Stream for unlocked projects.
  final Stream<QuerySnapshot> _projectsStreamUnlocked = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'unlocked')
      .snapshots();
  
  // Initializes the state and fetches necessary data.
  @override
  void initState() {
    super.initState();
    getLevel();
    checkEmailVerification();
    _loadAvatar();
    fetchPseudo();
  }

  
// Fetches the user's pseudo from authentication service.
Future<void> fetchPseudo() async {
  try {
    setState(() {
      pseudo = ''; 
    });

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

  // Checks if the user's email is verified.
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

// Fetches the user's level and XP data from Firestore.
Future<void> getLevel() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      print('utilisateur: ${userDoc.data()}');
      if (userDoc.exists) {
        setState(() {
          lvl = userDoc.data()?['currentLvl'] ?? 0; 
          xp = userDoc.data()?['currentXp'].toDouble(); 
          objXp = userDoc.data()?['objectiveXp'].toDouble(); 
        });
      } else {
        print('Le document utilisateur n\'existe pas');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur : $e');
    }
  }
}


  // Returns the rank based on the user's level.
  getlvlRank(int level){
    if(level >= 0 || level <= 5){
      return 'DEBUTANT';
    }
    return 'NOVICE';
  }

  // Returns the badge icon based on the user's level.
  getlvlBadge(int level){
    String path = 'assets/icons/';
    if(level >= 0 || level <= 5){
      return '${path}BronzeIcon.png';
    }
    return '${path}BronzeIcon.png';
  }


// Displays the greeting and message for the user.
Widget _title(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width *0.6 ,
            child: pseudo == null
        ? CircularProgressIndicator() // Affichage du chargement
        :  Text(
          'Salut, $pseudo 👋',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: customColor?.white?? Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.clip
            )
          ),
        ),
      ),
        SizedBox(height: 5,),
        Text(
          "Code en t'amusant",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: customColor?.white?? Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400
            )
          )
        )
    ],
  );
}

// Displays the user's profile picture.
Widget _profilePicture(){
  return CircleAvatar(
    backgroundImage:_avatarImage != null
        ? MemoryImage(_avatarImage!)
        : AssetImage('assets/icons/logo.png')
            as ImageProvider,
    radius: 45,
  );
}
// Displays the user's level and XP progress.
Widget _playerLevel() {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('Users').doc(uid).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return Center(child: Text("Chargement..."));
      }

      // Récupération des données Firestore en temps réel
      var userData = snapshot.data!.data() as Map<String, dynamic>;
      int currentLvl = userData['currentLvl'];
      double currentXp = userData['currentXp'].toDouble();
      double objectiveXp = userData['objectiveXp'].toDouble();

      return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: customColor?.blueback?? Color(0xff0692C2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: customColor?.blueback?? Color(0xff0692C2).withOpacity(0.5),
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
                  getlvlRank(currentLvl),
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: customColor?.white?? Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xffE6E6E6).withOpacity(0.64),
                    borderRadius: BorderRadius.circular(10),
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
                              text: '$currentLvl',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  color: customColor?.dark ?? Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      Image(
                        image: AssetImage(getlvlBadge(currentLvl)),
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 25,
              child: Progressbar(
                percentageCompletion: (currentXp / objectiveXp) * 100,
                showPercentage: false,
              ),
            ),
            Row(
              children: [
                Text(
                  "${currentXp.toStringAsFixed(0)} xp",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: customColor?.white?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "${objectiveXp.toStringAsFixed(0)} xp",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: customColor?.white?? Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),  
          ],
        ),
      );
    },
  );
}
// Displays projects from a given stream.
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
                style: TextStyle(color: customColor?.white?? Colors.white,),
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
  // Builds the HomePage widget.
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    customColor = Theme.of(context).extension<CustomColors>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),
                   customColor?.midnightBlue ?? Color.fromRGBO(0, 113, 152, 1),
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
                              color: customColor?.white?? Colors.white,
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
                                builder: (context) =>  ProjectsPage() //ProjectsPage(),
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
