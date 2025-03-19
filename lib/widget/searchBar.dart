import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/pages/games/projects/project_detail_page.dart';

/// Search bar widget with a floating design, supporting query updates and user interactions.
class Searchbar extends StatefulWidget {
  const Searchbar({super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

/// Manages search input, displays suggestions, and handles user actions.
class _SearchbarState extends State<Searchbar> {

  final FloatingSearchBarController controller = FloatingSearchBarController();

  String _searchQuery = ''; // Variable pour la requête utilisateur

  Widget _buildSearchResults() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('Projects').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Erreur lors du chargement des résultats.'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('Aucun projet trouvé.'));
      }

      // Vérifier si la requête de recherche est vide
      String query = _searchQuery.trim().toLowerCase();
      print("Search Query: $query"); // Debug

      final filteredDocs = snapshot.data!.docs.where((document) {
        final project = document.data() as Map<String, dynamic>;
        final name = (project['name'] ?? '').toString().toLowerCase();
        
        // Ne filtrer que si la requête de recherche n'est pas vide
        if (query.isEmpty) return true;  
        
        return name.contains(query);
      }).toList();

      if (filteredDocs.isEmpty) {
        return Center(child: Text('Aucun projet trouvé pour "$_searchQuery".'));
      }

      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: filteredDocs.map((DocumentSnapshot document) {
          final project = document.data() as Map<String, dynamic>;
          return ListTile(
            leading: Icon(Icons.school, color: Colors.black),
            title: Text(
              project['name'],
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            onTap: () {
              if (project['name'] == "Portfolio") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProjectDetailPage(
                        projet: project,
                        projetName: project['name'],
                      );
                    },
                  ),
                );
              }
            },
          );
        }).toList(),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
          hint: 'Cherche un projet...',
          scrollPadding: const EdgeInsets.only(top: 13, bottom: 56),
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          debounceDelay: const Duration(milliseconds: 500),
          physics: const BouncingScrollPhysics(),
          controller: controller,
          automaticallyImplyBackButton: false,
          backdropColor: Colors.transparent,
          closeOnBackdropTap: true,
          onQueryChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: const Icon(Icons.search), 
                onPressed: (){})
              ),
            FloatingSearchBarAction(
              showIfOpened: true,
              showIfClosed: false,
              child: CircularButton(
                icon: const Icon(CupertinoIcons.clear), 
                onPressed: (){  
                  controller.close();
                })
              ),
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
        );
    }
  }
