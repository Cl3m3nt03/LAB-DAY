import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/pages/games/projects/project_detail_page.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card widget that displays project details, progress, and navigates to the project detail page.
class ProjectCard extends StatefulWidget {
  final Map<String, dynamic> projet;
  const ProjectCard({super.key, required this.projet});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final double _projectCardWidth = 150;
  final double _projectCardHeight = 300;
  double percentageCompletion = 0;

  @override
  void initState() {
    super.initState();
    _fetchCurrentStep();
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  _fetchCurrentStep();  
}


Future<void> _fetchCurrentStep() async {
  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DocumentReference userProjectDocRef = FirebaseFirestore.instance
        .collection('Users')  // Accéder à la collection Users
        .doc(userId)          // Sélectionner l'utilisateur connecté
        .collection(widget.projet['name']) // Accéder au projet spécifique de cet utilisateur
        .doc('levelMap');     // Aller dans le document levelMap

    print("ICI $userProjectDocRef");

    DocumentSnapshot projectDoc = await userProjectDocRef.get();

    if (!projectDoc.exists) {
      await userProjectDocRef.set({"currentStep": 0});
      setState(() {
        percentageCompletion = 0;
      });
      return;
    }

    int currentStep = projectDoc["currentStep"];
    setState(() {
      percentageCompletion = (currentStep / 20) * 100;
    });

  } catch (e) {
    print("Error fetching currentStep: $e");
  }
}



  @override
  Widget build(BuildContext context) {
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
            image: AssetImage('assets/images/${widget.projet['name']}.jpg'),
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
                            widget.projet['name'],
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          if (widget.projet['state'] == 'began')
                            Progressbar(
                              percentageCompletion: percentageCompletion,
                              showPercentage: true,
                            ),
                          if (widget.projet['state'] == 'unlocked') showMore(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProjectDetailPage(
                projet: widget.projet,
                projetName: widget.projet['name'],
              );
            },
          ),
        );
      },
    );
  }

  Widget showMore() {
    return Container(
      height: 23,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: <Color>[
            Color(0xff0b0c0d),
            Color(0xff0d1e30),
          ],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Commencer',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              fontSize: 9,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
