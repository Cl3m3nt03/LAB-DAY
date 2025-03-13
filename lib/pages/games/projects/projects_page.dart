import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/pages/games/projects/glossary_page.dart';
import 'package:makeitcode/pages/games/projects/project_detail_page.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:makeitcode/widget/project_card.dart';
import 'package:makeitcode/widget/searchBar.dart';

// Defines the ProjectsPage widget
// Manages the state and UI of the Projects page
class ProjectsPage extends StatefulWidget {
  // Constructor for ProjectsPage
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

// Manages the state for the ProjectsPage
class _ProjectsPageState extends State<ProjectsPage> {
  // Streams for different project states
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
  // Dimensions for project cards

  final double _projectCardWidth = 150;
  final double _projectCardHeight = 300;
  // Controller for the floating search bar

  final FloatingSearchBarController controller = FloatingSearchBarController();

  // Controller for scrolling
  ScrollController _scrollController = ScrollController();
  // Flag to track if the user has scrolled

  bool _isScrolled = false;

  // Stores the user's search query
  String _searchQuery = ''; 
  
  // Builds the title widget for the Projects page
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

// Builds the search results widget
// Filters projects based on the search query
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
      // Filters the documents based on the search query
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

  // Builds the project card for locked projects
  // Displays a locked project with a lock icon
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
// Builds the project list widget for a given stream of projects
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
                    return ProjectCard(projet: projet);
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
  // Builds the small title widget

  Widget _smallTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Monsterrat',
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

@override
  // Builds the main UI for the Projects page
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Text('PROJECTS',style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),),
),
      backgroundColor: Color.fromARGB(255, 11, 22, 44),
      centerTitle: true,
    ),
    resizeToAvoidBottomInset: false,
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
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 11),
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
          Align(
            alignment: Alignment.topCenter,
            child: Searchbar(searchBuilder: _buildSearchResults()),
          ),
      ],
    ),
  );
}


}
