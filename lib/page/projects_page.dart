import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/register_page.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/page/project_detail_page.dart';
import 'package:swipeable_button/swipeable_button.dart';
import 'glossary_page.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final Stream<QuerySnapshot> _projectsStreamBegan = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'began')
      .snapshots();
  final Stream<QuerySnapshot> _projectsStreamUnlocked = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'unlocked')
      .snapshots();
  final Stream<QuerySnapshot> _projectsStreamBlocked = FirebaseFirestore.instance
      .collection('Projects')
      .where('state', isEqualTo: 'locked')
      .snapshots();

  final double _projectCardWidth = 150;
  final double _projectCardHeight = 300;

  String _searchQuery = ''; // Variable pour la requête utilisateur

  Widget _title() {
    return Text(
      'Projets',
      style: TextStyle(
        fontFamily: 'Monsterrat',
        fontWeight: FontWeight.w800,
        fontSize: 36,
        color: Colors.white,
      ),
    );
  }

Widget _searchBar() {
  return Container(
    height: 400, 
    child: FloatingSearchBar(
      hint: 'Cherche un projet...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      debounceDelay: const Duration(milliseconds: 500),
      physics: const BouncingScrollPhysics(),
      onQueryChanged: (query) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
        });
      },
      actions: [
        FloatingSearchBarAction.searchToClear(showIfClosed: false),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 0,
            child: _buildSearchResults(),
          ),
        );
      },
    ),
  );
}

Widget _buildSearchResults() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Projects')
        .snapshots(), // On récupère tous les projets
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      }
      if (snapshot.hasError) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: Text('Erreur lors du chargement des résultats.'),
        );
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: Text('Aucun projet trouvé.'),
        );
      }

      final filteredDocs = snapshot.data!.docs.where((document) {
        final project = document.data() as Map<String, dynamic>;
        final name = (project['name'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery);
      }).toList();

      if (filteredDocs.isEmpty) {
        return Container(
          height: 100,
          alignment: Alignment.center,
          child: Text('Aucun projet trouvé pour "$_searchQuery".'),
        );
      }

      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: filteredDocs.map((DocumentSnapshot document) {
          final project = document.data() as Map<String, dynamic>;
          return ListTile(
              leading: Icon(Icons.school),
              title: Text(
                project['name'],
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500
                    )
                )
              ),
              onTap: (){},
          );
        }).toList(),
      );
    },
  );
}


  Widget _projectCardLocked(projet) {
  return Container(
    height: _projectCardHeight,
    width: _projectCardWidth,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 4,
          offset: Offset(2, 2),
        )
      ],
    ),
    child: Stack(
      children: [
        // Image en arrière-plan
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: AssetImage('assets/images/${projet['name']}.jpg'),
            fit: BoxFit.cover,
            height: _projectCardHeight,
            width: _projectCardWidth,
          ),
        ),
        // Couche noire semi-transparente
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.black.withOpacity(0.92),
            height: _projectCardHeight,
            width: _projectCardWidth,
          ),
        ),
        // Icône de cadenas au centre
        Center(
          child: Icon(
            Icons.lock, 
            size: 40, 
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}

Widget showMore(){
    return Container(
      height: 23,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            Color(0xff0b0c0d),
            Color(0xff0d1e30),
          ]
        ),
        borderRadius: BorderRadius.circular(50)
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
        ),
        onPressed: (){}, 
        child: Text(
          'Commencer',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white
            ),
          )
        )
    );
  }


  Widget _projectsCard(projet) {
    double percentageCompletion = (projet['actualStep'] / projet['nbSteps']) * 100;
    return InkWell(
      child: Container(
          height: _projectCardHeight,
          width: _projectCardWidth,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              )
            ],
            image: DecorationImage(
              image: NetworkImage(projet['image'].toString()),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                            height: 60,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    projet['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Monsterrat',
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(height: 5),

                                  if(projet['state'] == 'began')
                                  Container(
                                    height: 15,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (percentageCompletion > 30)
                                          Container(
                                            height: double.maxFinite,
                                            width: percentageCompletion,
                                            decoration: BoxDecoration(
                                              color: Color(0xffE8B228),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 4),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  '${percentageCompletion.truncate()}%',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        if (percentageCompletion <= 30)
                                          Container(
                                            height: double.maxFinite,
                                            width: percentageCompletion,
                                            decoration: BoxDecoration(
                                              color: Color(0xffE8B228),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                        if (percentageCompletion <= 30)
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${percentageCompletion.truncate()}%',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if(projet['state'] == 'unlocked')
                                  showMore(),

                                ],
                              ),
                            ),
                          ),
                  ),
                )
              )
            ],
          ),
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return ProjectDetailPage(projet: projet, projetName: projet['name'],);
            }
          ));
        },
    );
  }

  Widget _projects(String title, Stream<QuerySnapshot<Object?>> stream) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: _smallTitle(title),
        ),
        SizedBox(height: 16),
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

                  if (projet['state'] != 'locked') {
                    return _projectsCard(projet);
                  } else {
                    return _projectCardLocked(projet);
                  }
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _smallTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Monsterrat',
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 25,
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: GlossaryPage(),
    floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    body: Stack(
      children: [
        // Contenu principal
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(0, 113, 152, 1), Color.fromARGB(255, 11, 22, 44)],
              stops: [0.2, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.center,
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 22),
                    Align(
                      alignment: Alignment.topLeft,
                      child: _title(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    _projects('En cours', _projectsStreamBegan),
                    _projects('Débloqués', _projectsStreamUnlocked),
                    _projects('Bloqués', _projectsStreamBlocked),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Barre de recherche en position absolue
        Positioned(
          top: 110, // Distance depuis le haut
          left: 20, // Distance depuis la gauche
          right: 20, // Distance depuis la droite
          child: _searchBar(),
        ),
      ],
    ),
  );
}

}
