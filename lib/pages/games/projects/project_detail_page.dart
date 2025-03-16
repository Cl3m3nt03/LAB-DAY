import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/rewardScreen.dart';
import 'package:makeitcode/pages/games/projects/levelMap.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        'Structure de base': '',
        'Nom par défaut': 'Nom par défaut',
        'À propos par défaut': 'À propos par défaut',
        'Email par défaut': 'Email par défaut',
        'Téléphone par défaut': 'Téléphone par défaut',
        'Compétence 1': 'Compétence 1',
        'Compétence 2': 'Compétence 2',
        'Projet 1': 'Projet 1',
        'Projet 2': 'Projet 2',
        'Ajout d\'une image': 'Image par défaut',
        'Ajout de liens externes': 'Lien par défaut',
        "Ajout d'un lien vers GitHub": 'Lien par défaut',
        'Tableau des compétences':'Tableau par défaut',
        "Ajout d'une section 'Compétences techniques'": 'Section par défaut',
        'Ajout d\'une liste de projets': 'Liste par défaut',
        'Section de témoignages': 'Section par défaut',
        "Ajout d'un formulaire de contact": 'Formulaire par défaut',
        "Ajout d'un bouton 'Retour en haut'" : 'Bouton par défaut',
        'Footer': 'Footer par défaut',
        'Finalisation du portfolio': 'Finalisation par défaut',
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

    _projectDetail = FirebaseFirestore.instance
    .collection('Projects')
    .where('name', isEqualTo: widget.projetName)
    .snapshots();
    initProject();
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
                PolygonBoxShadow(color: Colors.black, elevation: 1.0),
                PolygonBoxShadow(color: Color(0xff5FC2BA), elevation: 5.0),
              ],
              child: Container(
                height: 200, // Ajustez la hauteur
                width: 400, // Ajustez la largeur
                decoration: BoxDecoration(
                  color: Colors.black,
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
  return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Color(0xff0692C2).withOpacity(0.7),
                          Color(0xffE8B228).withOpacity(0.7)
                        ]
                      )
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                ),
              ],
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
                          color: Colors.white,
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
                            color: Color(0xffE8B228),
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
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '4.3',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
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
                  color: Color(0xff0B0F2C),
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
                color: Color(0xff346094), // Couleur du fond
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

Widget _stepCard(step){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Color(0xff0692C2),
      boxShadow: [
        BoxShadow(
          color: Color(0xff346094),
          blurRadius: 4,
          offset: Offset(0, 3)
        )
      ]
    ),
    child: Center(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                step['name'],
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)
                ),
              ),
            ],
          ),
          Spacer(),
          if(step['isCompleted'])
          Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xffa0ca85),
          ),
          if(!step['isCompleted'])
          Icon(
            CupertinoIcons.clear_circled,
            color: Color(0xffaf3a36),
          )
        ],
      )
      ),
  );
}
// Widget to generate steps card from Firestore data.

Widget _stepsCardGeneration() {
  return StreamBuilder<QuerySnapshot>(
    stream: _projectDetail,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Erreur: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('Aucun projet trouvé'));
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> project = document.data()! as Map<String, dynamic>;

            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Projects')
                  .doc(document.id)
                  .collection('Steps')
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> stepSnapshot) {
                if (stepSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (stepSnapshot.hasError) {
                  return const Text("Erreur lors du chargement des étapes.");
                }

                return Column(
                  children: stepSnapshot.data!.docs.map((stepDocument) {
                    Map<String, dynamic> step = stepDocument.data()! as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _stepCard(step),
                    );
                  }).toList(),
                );
              },
            );
          }).toList(),
        ),
      );
    },
  );
}
// Widget to generate project description text from Firestore data.

Widget _descriptionTextGeneration() {
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

// Widget to display all steps or description depending on the selected tab.

Widget _allStepsCard(double screenHeight) {
  return Positioned(
    top: screenHeight / 1.6,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    child: Container(
      height: 200,
      width: 270,
      child: _selectedIndex == 0
          ? _stepsCardGeneration() // Affiche les étapes si "Etapes" est sélectionné
          : _selectedIndex == 1
              ? _descriptionTextGeneration()
              : const Center(
                  child: Text('Avis des utilisateurs', style: TextStyle(color: Colors.white)),
                ),
    ),
  );
}



Future<String> _getButtonText() async {
  final userId = FirebaseAuth.instance.currentUser!.uid; // Identifiant de l'utilisateur actuel
  final docRef = FirebaseFirestore.instance
      .collection('Users') // Collection des utilisateurs
      .doc(userId) // Document de l'utilisateur actuel
      .collection('Portfolio') // Collection de portfolio spécifique à l'utilisateur
      .doc('levelMap') // Le document de niveau (levelMap)
      .get(); // Récupérer les données de ce document
  
  final docSnapshot = await docRef;

  if (docSnapshot.exists) {
    int currentStep = docSnapshot['currentStep'] ?? 1; // Si 'currentStep' existe, on l'utilise
    return currentStep == 1 ? "Commencer" : "Continuer"; // Si currentStep == 1, afficher "Commencer"
  } else {
    return "Erreur"; // Par défaut, si aucune donnée trouvée, afficher "erreur"
  }
}





Widget _confirmButton(double screenHeight) {
  return Positioned(
    top: screenHeight / 1.13,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    child: FutureBuilder<String>(
      future: _getButtonText(),  // Appel de la fonction asynchrone
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Affichage du chargement si la requête est en cours
        }

        if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');
        }

       // Vérification si les données sont présentes
        String buttonText = snapshot.data ?? "Commencer"; // Si pas de texte, afficher "Commencer" par défaut

        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
            backgroundColor: const Color(0xff121B38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            shadowColor: const Color(0xff121B38).withOpacity(0.6), // Ombre
            elevation: 8,
          ),
          onPressed: () async {
            try {
              // Récupérer le document correspondant au projet actuel
              QuerySnapshot projectSnapshot = await FirebaseFirestore.instance
                  .collection('Projects')
                  .where('name', isEqualTo: widget.projetName)
                  .get();

              if (projectSnapshot.docs.isNotEmpty) {
                DocumentSnapshot projectDoc = projectSnapshot.docs.first;
                Map<String, dynamic> projectData = projectDoc.data() as Map<String, dynamic>;
                String projectId = projectDoc.id; // ID du projet

                // Ajouter l'ID au projet pour qu'il puisse être utilisé dans Rewardscreen
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
                // Afficher une erreur si aucun projet trouvé
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Projet introuvable")),
                );
              }
            } catch (e) {
              // Gestion des erreurs Firestore
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Erreur: ${e.toString()}")),
              );
            }
          },
          child: Text(
            buttonText,  // Utilisation du texte récupéré
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
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(0, 113, 152, 1), Color.fromARGB(255, 11, 22, 44)],
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
