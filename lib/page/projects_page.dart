import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/glossary_page.dart';
import 'package:makeitcode/page/register_page.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'glossary_page.dart';
import 'glossary_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {

  final Stream<QuerySnapshot> _projectsStreamBegan =
      FirebaseFirestore.instance.collection('Projects').where('state', isEqualTo: 'began').snapshots();
  final Stream<QuerySnapshot> _projectsStreamUnlocked =
      FirebaseFirestore.instance.collection('Projects').where('state', isEqualTo: 'unlocked').snapshots();
  final Stream<QuerySnapshot> _projectsStreamBlocked =
      FirebaseFirestore.instance.collection('Projects').where('state', isEqualTo: 'blocked').snapshots();

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

  Widget _SearchBar() {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          hintText: 'Rechercher un projet...',
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
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

  Widget _projectsCard(projet) {
    double percentageCompletion = (projet['actualStep'] / projet['nbSteps']) * 100;
    return Container(
      height: 300,
      width: 150,
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
                            ],
                          ),
                        ),
                      ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _projects(String title, Stream) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: _smallTitle(title),
        ),
        SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: Stream,
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
                  return _projectsCard(projet);
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GlossaryPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: Container(
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
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  _SearchBar(),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  _projects('En cours',_projectsStreamBegan),
                  _projects('Débloqués', _projectsStreamUnlocked),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
