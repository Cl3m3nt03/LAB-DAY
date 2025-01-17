import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> projet;
  final String projetName;

  const ProjectDetailPage({super.key, required this.projet, required this.projetName});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late final Stream<QuerySnapshot> _projectDetail;
  int _selectedIndex = 0;

  void _cheangeIndex(int index){
      setState(() {
        _selectedIndex = index;
      });
  }

  @override
   void initState(){
    super.initState();

    _projectDetail = FirebaseFirestore.instance
    .collection('Projects')
    .where('name', isEqualTo: widget.projetName)
    .snapshots();
   }

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
                      style: GoogleFonts.aBeeZee(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      )
                    ),
                    SizedBox(width: 100),
                    Center(
                      child: Text(
                        'Gratuit',
                        style: GoogleFonts.sora(
                          textStyle: TextStyle(
                            color: Color(0xffE8B228),
                            fontWeight: FontWeight.w400,
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
                      style: GoogleFonts.sora(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w400
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
                    style: GoogleFonts.sora(
                      textStyle: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.white,
                        fontWeight: FontWeight.w500,
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

// Fonction pour calculer la largeur dynamique d'un bouton avec un padding
double _calculateButtonWidth(int index, List<String> buttonTexts) {
  final TextStyle textStyle = GoogleFonts.sora().copyWith(fontWeight: FontWeight.w600);
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: buttonTexts[index], style: textStyle),
    textDirection: TextDirection.ltr,
  )..layout();
  return textPainter.width + 40; // Ajoute un padding horizontal de 20px de chaque côté (total 40px)
}



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

Widget _allStepsCard(screenHeight) {
  return Positioned(
    top: screenHeight / 1.6,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    child: Container(
      height: 200,
      width: 270,
      child: _selectedIndex == 0
          ? _stepsCardGeneration() // Affiche les étapes si le bouton "Etapes" est sélectionné
          : _selectedIndex == 1
              ? Center(child: Text('Description du projet', style: TextStyle(color: Colors.white)))
              : Center(child: Text('Avis des utilisateurs', style: TextStyle(color: Colors.white))),
    ),
  );
}


Widget _confirmButton(screenHeight) {
  return Positioned(
    top: screenHeight / 1.13,
    left: (MediaQuery.of(context).size.width - 270) / 2,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 12),
        backgroundColor: const Color(0xff121B38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        shadowColor: const Color(0xff121B38).withOpacity(0.6), // Couleur de l'ombre
        elevation: 8, // Intensité de l'ombre
      ),
      onPressed: () {},
      child: Text(
        'Continuer',
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
