import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/rewardScreen.dart';
import 'package:makeitcode/pages/games/projects/levelMap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:makeitcode/theme/custom_colors.dart';

class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> projet;
  final String projetName;
  const ProjectDetailPage({super.key, required this.projet, required this.projetName});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late final Stream<QuerySnapshot> _projectDetail;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  int _currentStep = 0;
  String _titleStep = "";
  CustomColors? customColor;


  void _cheangeIndex(int index){
      setState(() {
        _selectedIndex = index;
      });
  }
  Future _initData(userId) async {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userId).collection('Portfolio').doc('data');
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'title': 'Titre par défaut',
        'about': 'Description par défaut',
        'email': 'Email par défaut',
        'phone': 'Numéro de téléphone par défaut',
        'skill1': 'Compétence 1',
        'skill2': 'Compétence 2',
        'project1': 'Projet 1',
        'project2': 'Projet 2',
        'link1': 'Lien 1',
        'link2': 'Lien 2',
        'tech_skills': 'tech_skills',
        'button': 'Valider',
        'footer_info': 'Footer par défaut',
        'css': 'dark'
      });
    }
  }
    Future _initLevelMap(userId) async {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userId).collection('Portfolio').doc('levelMap');
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'currentStep': 1,
      });
    }
  }
  @override
   void initState(){
    super.initState();
    initProject();
    _fetchCurrentStep();
   }

Future<void> initProject() async {
  final docRef = _firestore
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("Projects")
      .doc(widget.projetName);

  final docSnapshot = await docRef.get();
  if (!docSnapshot.exists) {
    await docRef.set({
      'title':"title",
      'description':"description",
      });
  } else {
  }
}

Future<void> _fetchCurrentStep() async {
  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DocumentReference userProjectDocRef = FirebaseFirestore.instance
        .collection('Users')  // Accéder à la collection Users
        .doc(userId)          // Sélectionner l'utilisateur connecté
        .collection(widget.projet['name']) 
        .doc('levelMap');     // Aller dans le document levelMap

    print("ICI $userProjectDocRef");

    DocumentSnapshot projectDoc = await userProjectDocRef.get();

    if (!projectDoc.exists) {
      await userProjectDocRef.set({"currentStep"});
      return;
    }
    _currentStep = projectDoc["currentStep"];

  } catch (e) {
    print("Error fetching currentStep: $e");
  }
}

Future<String> loadContent(int step) async {
  try {
    String jsonString = await rootBundle.loadString('assets/game/html.json');
    List<dynamic> jsonData = json.decode(jsonString);

    var stepData = jsonData.firstWhere((element) => element["step"] == step, orElse: () => {});

    if (stepData.isEmpty) {
      throw Exception("Aucune donnée trouvée pour l'étape $step");
    }

    print("Donnée ${stepData['title']} $step");

    return stepData["title"]; // Retourne le titre au lieu de modifier _titleStep
  } catch (e) {
    print("Erreur lors du chargement de l'étape $step : $e");
    return "Erreur";
  }
}



// Widget to render the project image poster with polygon shape.
Widget _ImagePoster(){
  return Positioned(
            top: -150, 
            left: -50, 
            right: -50, 
            child: ClipPolygon(
              sides: 9,
              borderRadius: 30,
              rotate: 90,
              boxShadows: [
                PolygonBoxShadow(color: customColor?.dark ?? Colors.black, elevation: 1.0),
                PolygonBoxShadow(color: Color.fromARGB(255, 246, 255, 254), elevation: 5.0),
              ],
              child: Container(
                height: 200, // Ajustez la hauteur
                width: 400, // Ajustez la largeur
                decoration: BoxDecoration(
                  color: customColor?.dark ?? Colors.black,
                  image: DecorationImage(
                      image: AssetImage('assets/images/${widget.projet['name']}.jpg'),
                      fit: BoxFit.cover,
                  )
                ),
              ),
            ),
          );
}
// Widget for the back arrow icon with custom gradient style.

Widget _backArrow(){
  return Positioned(
            top: 40,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'backButton',
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.white.withOpacity(0.8),
              elevation: 3,
              mini: true,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          );
}

// Widget for displaying project title and its details such as 'Gratuit' and rating.

Widget _title(screenHeight){
  return Positioned(
            top: screenHeight/2.35,
            left: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.projet['name'], 
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: customColor?.whiteAll?? Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      )
                    ),
                    SizedBox(width: 85),
                    Center(
                      child: Text(
                        'Gratuit',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: customColor?.blueback?? Color(0xffE8B228),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        )
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_outline_rounded, 
                      color:  customColor?.blueback?? Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '5',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: customColor?.blueback?? Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600
                        ),
                      )
                    )
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          );
}



// Widget to generate a selector for project steps, description, and reviews.

Widget _selector(screenHeight) {
  // Textes des boutons
  List<String> buttonTexts = ['Etapes', 'Description     ', 'Avis'];

  return Positioned(
    top: screenHeight / 1.85,
    left: (MediaQuery.of(context).size.width - 320) / 2, // Centrer la ligne
    child: Container(
      height: 60, // Hauteur totale du sélecteur
      width: 320, // Largeur totale du sélecteur
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Expanded(
            child: Container(
                height: 40.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: customColor?.midnightIndigo?? Color(0xff0B0F2C),
                ),
              )
            ),
          ),
          // Fond animé derrière le bouton actif
          AnimatedAlign(
            duration: Duration(milliseconds: 300),
            alignment: _selectedIndex == 0
                ? Alignment.centerLeft
                : _selectedIndex == 1
                    ? Alignment.center
                    : Alignment.centerRight,
            child: Container(
              width: _calculateButtonWidth(_selectedIndex, buttonTexts), // Largeur dynamique de chaque bouton
              height: 40, // Hauteur du fond
              decoration: BoxDecoration(
                color:customColor?.blueback??  Color.fromARGB(255, 30, 123, 230), // Couleur du fond
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          // Boutons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttonTexts.asMap().entries.map((entry) {
              int index = entry.key;
              String text = entry.value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index; // Mise à jour de l'indice actif
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20), // Ajoute un padding autour du texte
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}

// Helper function to calculate button width dynamically based on the text length.
double _calculateButtonWidth(int index, List<String> buttonTexts) {
  final TextStyle textStyle = GoogleFonts.montserrat().copyWith(fontWeight: FontWeight.bold);
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: buttonTexts[index], style: textStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  return textPainter.width + 40; // Ajoute un padding horizontal de 20px de chaque côté (total 40px)
}


// Widget to generate a step card with information about each project step.

Widget _stepCard(String title, int step) {
  customColor = Theme.of(context).extension<CustomColors>();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: customColor?.blueback ?? Color(0xff0692C2),
      boxShadow: [
        BoxShadow(
          color: customColor?.blueback?? Color(0xff346094),
          blurRadius: 4,
          offset: Offset(0, 3)
        )
      ]
    ),
    child: Center(
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Aligne les éléments verticalement
    children: [
      Container(
        width: 190, // Largeur fixe que tu souhaites pour le texte (ajuste selon ton besoin)
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          maxLines: 1, // Limite à une seule ligne
          overflow: TextOverflow.ellipsis, // Ajoute "..." si le texte dépasse
        ),
      ),
      Spacer(),
      if (_currentStep-1 >= step)
        Icon(
          Icons.check_circle_outline_rounded,
          color: Color(0xffa0ca85),
        )
      else
        Icon(
          CupertinoIcons.clear_circled,
          color: Color(0xffaf3a36),
        ),

          ],
        ),
),

  );
}

// Widget to generate steps card from Firestore data.

// Widget to generate project description text from Firestore data.

Widget _descriptionTextGeneration() {
  customColor = Theme.of(context).extension<CustomColors>();
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Projects')
        .where('name', isEqualTo: widget.projetName)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Erreur: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('Aucun projet trouvé', style: TextStyle(color: Colors.white)));
      }

      // On prend le premier projet trouvé (supposant qu'un seul correspond au nom donné)
      var project = snapshot.data!.docs.first.data()! as Map<String, dynamic>;
      return Padding(
        padding: const EdgeInsets.all(10),
        child: _descriptionText(context , project['description'] ?? 'Pas de description disponible'),
      );
    },
  );
}

// Widget to display description text with custom styling and gradient background.

Widget _descriptionText(BuildContext context, String desc) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      //constraints: const BoxConstraints(maxWidth: 300, maxHeight: 200), // Taille max
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(141, 117, 179, 0.702),
            Color.fromRGBO(70, 46, 109, 0.851)
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(3, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: -2,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 225, 240, 254),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _userRatings(){
  return SingleChildScrollView(
    child: Column(
    children: [
      Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: customColor?.blueback?? Color(0xff0692C2),
      boxShadow: [
        BoxShadow(
          color: Color(0xff346094),
          blurRadius: 4,
          offset: Offset(0, 3)
        )
      ]
    ),
    child: Center(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Alignement des éléments horizontalement (par défaut start)
children: [
  // Premier Container avec le texte du nom
  Container(
    width: 200, 
    child: Text(
      'Jack',
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ),
  ),
Container(
  width: 240, 
  height: 40, 
  child: Stack(
    children: [
      for (int i = 0; i < 5; i++)
        Positioned(
          left: i * 20.0, 
          top: 0, 
          child: Icon(
            Icons.star_rate_rounded,
            color: i < 5 ? Colors.yellow : Colors.grey, 
          ),
        ),
    ],
  ),
),

  Container(
    width: 300, 
    child: Text(
      "Ce projet de portfolio a été une excellente occasion d'apprendre et d'appliquer des compétences en développement web. J'ai pu créer un site pour afficher mes projets, ce qui m'a permis de mieux comprendre le processus de création web et d'améliorer mes compétences techniques.",
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w700),
      ),
    ),
  ),
],

)

),

  ),

  SizedBox(height: 20),

  Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: customColor?.blueback?? Color(0xff0692C2),
      boxShadow: [
        BoxShadow(
          color: Color(0xff346094),
          blurRadius: 4,
          offset: Offset(0, 3)
        )
      ]
    ),
    child: Center(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Alignement des éléments horizontalement (par défaut start)
children: [
  // Premier Container avec le texte du nom
  Container(
    width: 200, 
    child: Text(
      'Jones',
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ),
  ),
Container(
  width: 240, 
  height: 40, 
  child: Stack(
    children: [
      for (int i = 0; i < 5; i++)
        Positioned(
          left: i * 20.0, 
          top: 0, 
          child: Icon(
            Icons.star_rate_rounded,
            color: i < 5 ? Colors.yellow : Colors.grey, 
          ),
        ),
    ],
  ),
),

  Container(
    width: 300, 
    child: Text(
      "Le projet portfolio m'a aidé à maîtriser plusieurs compétences techniques tout en créant un site pour présenter mes réalisations. C'est un excellent moyen de voir mes progrès et de gagner en confiance.",
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w700),
      ),
    ),
  ),
],

)

),

  ),


  SizedBox(height: 20,),

  Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: customColor?.blueback?? Color(0xff0692C2),
      boxShadow: [
        BoxShadow(
          color: Color(0xff346094),
          blurRadius: 4,
          offset: Offset(0, 3)
        )
      ]
    ),
    child: Center(
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start, // Alignement des éléments horizontalement (par défaut start)
children: [
  // Premier Container avec le texte du nom
  Container(
    width: 200, 
    child: Text(
      'Tyron',
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    ),
  ),
Container(
  width: 240, 
  height: 40, 
  child: Stack(
    children: [
      for (int i = 0; i < 5; i++)
        Positioned(
          left: i * 20.0, 
          top: 0, 
          child: Icon(
            Icons.star_rate_rounded,
            color: i < 5 ? Colors.yellow : Colors.grey, 
          ),
        ),
    ],
  ),
),

  Container(
    width: 300, 
    child: Text(
      "Ce projet de portfolio m'a permis d'apprendre à créer des sites web de A à Z. Grâce à lui, j'ai mis en pratique mes compétences en HTML, CSS et JavaScript, et j'ai pu présenter mes projets de manière professionnelle.",
      style: GoogleFonts.montserrat(
        textStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w700),
      ),
    ),
  ),

],
)
),
  ),
    SizedBox(height: 60,),
    ],
  ),
  );
}

// Widget to display all steps or description depending on the selected tab.

Widget _allStepsCard(double screenHeight) {
  return Positioned(
    top: screenHeight / 1.6,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    child: Container(
      height: 200,
      width: 270,
      child: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 1; i <= 20; i++)
                    FutureBuilder<String>(
                      future: loadContent(i), // Charge le titre de l'étape
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return Text("Erreur pour l'étape $i");
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _stepCard(snapshot.data!, i), // Passe le titre récupéré
                        );
                      },
                    ),
                    SizedBox(height:60),
                ],
              ),
            )
          : _selectedIndex == 1
              ? _descriptionTextGeneration()
              : _selectedIndex == 2
                  ? Center(
                      child: _userRatings(),
                    )
                  : const SizedBox.shrink(), // Ajoute une condition vide si aucun index ne correspond
    ),
  );
}

Future<String> _getButtonText() async {
  final userId = FirebaseAuth.instance.currentUser!.uid; // Current user's ID
  final docRef = FirebaseFirestore.instance
      .collection('Users') // Users collection
      .doc(userId) // Current user's document
      .collection('Portfolio') // Portfolio collection specific to the user
      .doc('levelMap') // The level document (levelMap)
      .get(); // Retrieve the data of this document
  
  final docSnapshot = await docRef;

  if (docSnapshot.exists) {
    int currentStep = docSnapshot['currentStep'] ?? 1; // If 'currentStep' exists, use it
    return currentStep == 1 ? "Commencer" : "Continuer"; // If currentStep == 1, display "Start"
  } else {
    return "Erreur"; // Default, if no data found, display "error"
  }
}


Widget _confirmButton(screenHeight) {
  return Positioned(
    top: screenHeight / 1.13,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    right: (MediaQuery.of(context).size.width - 270) / 2,
    child: FutureBuilder<String>(
      future: _getButtonText(),  // Calling the asynchronous function
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while the request is in progress
        }

        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

        // Check if data is present
        String buttonText = snapshot.data ?? "Commencer"; 

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            backgroundColor: customColor?. midnightIndigo ?? Color(0xff121B38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            shadowColor: const Color(0xff121B38).withOpacity(0.6), // Ombre
            elevation: 8,
          ),
          onPressed: () async {
            try {
              // Retrieve the document corresponding to the current project
              QuerySnapshot projectSnapshot = await FirebaseFirestore.instance
                  .collection('Projects')
                  .where('name', isEqualTo: widget.projetName)
                  .get();

              if (projectSnapshot.docs.isNotEmpty) {
                DocumentSnapshot projectDoc = projectSnapshot.docs.first;
                Map<String, dynamic> projectData = projectDoc.data() as Map<String, dynamic>;
                String projectId = projectDoc.id; // ID du projet

                // Add the ID to the project so it can be used in RewardScreen
                projectData['id'] = projectId;

                await _initData(FirebaseAuth.instance.currentUser!.uid);
                await _initLevelMap(FirebaseAuth.instance.currentUser!.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Levelmap(),
                  ),
                );
              } else {
                // Show an error if no project is found
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Projet introuvable")),
                );
              }
            } catch (e) {
              // Handle Firestore errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur: ${e.toString()}")),
              );
            }
          },
          child: Text(
            buttonText,  
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [ customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1), customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44)],
                stops: [0.2, 0.9],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),

          _ImagePoster(),

          _backArrow(),

          _title(_screenHeight),

          _selector(_screenHeight),

          _allStepsCard(_screenHeight),

          _confirmButton(_screenHeight),
        ],
      ),
    );
  }
}
