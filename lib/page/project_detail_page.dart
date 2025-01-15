import 'package:cloud_firestore/cloud_firestore.dart';
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
                      image: NetworkImage(widget.projet['image'].toString()),
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
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Color(0xffE8B228).withOpacity(0.7),
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


Widget _selector(screenHeight){
  return Positioned(
            top: screenHeight/1.85,
            left: (MediaQuery.of(context).size.width - 190) / 2, // Centrer le container
            child: Row(
                  children: [
                    // Envelopper la Row avec un Container pour ajouter le fond
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff7086CB), // Fond de la Row
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff57356B).withOpacity(1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              'Etapes',
                              style: GoogleFonts.sora(
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xff57356B).withOpacity(0),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              'Description',
                              style: GoogleFonts.sora(
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
          );
}


Widget stepsCard(screenHeight){
  return Positioned(
    top: screenHeight/1.5,
    child: Container(
      height: 300,
      child: SingleChildScrollView(
        child: stepsCardGeneration(),
      ),
    )
  );
}

Widget stepsCardGeneration(){
  return StreamBuilder<QuerySnapshot>(
    stream: _projectDetail, 
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun projet trouvé'));
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> project = document.data()! as Map<String, dynamic>;

                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                  .collection('Projects')
                  .doc(document.id)
                  .collection('Steps')
                  .get(), 
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> stepSnapshot){
                    if (stepSnapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (stepSnapshot.hasError) {
                      return const Text("Erreur lors du chargement des etapes.");
                    }

                    return Column(
                      children: stepSnapshot.data!.docs.map((stepDocument){
                        Map<String, dynamic> step = stepDocument.data()! as Map<String, dynamic>;

                        return Text(step['step']);
                      }).toList(),
                    );
                  });
              }).toList(),
            );
    }
    );
}

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Fond en dégradé
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

          stepsCard(_screenHeight),
        ],
      ),
    );
  }
}
