import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:three_d_slider/three_d_slider.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/pages/games/home_game.dart';
import 'package:makeitcode/theme/custom_colors.dart';

/// Screen that displays the user's progress, step details, and rewards for a project.
class RewardscreenXp extends StatefulWidget {
  final int xpToAdd;
  final String title;
  const RewardscreenXp({super.key, required this.xpToAdd, required this.title});

  @override
  State<RewardscreenXp> createState() => _RewardscreenXpState();

  static void updateXp(int i) {}
}

/// Manages the state of the RewardscreenXp, including level, XP, and project step details.
class _RewardscreenXpState extends State<RewardscreenXp> {
  CustomColors? customColor;

  int lvl = 0;
  double xp = 0;
  double objXp = 100;

  String stepName = "";
  String stepDesc = "";

  @override

  /// Initializes user level and step data when the screen is loaded.
  void initState() {
    super.initState();
    getLevel();
    updateXp();
  }

Future<void> updateXp() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        double currentXp = userDoc.data()?['currentXp'].toDouble();
        int currentLvl = userDoc.data()?['currentLvl'] ?? 0;

        double newXp = currentXp + widget.xpToAdd;
        int newLvl = currentLvl;
        double newObjXp = userDoc.data()?['objectiveXp'].toDouble();


        while(newXp >= newObjXp){
          newXp -= newObjXp;
          newObjXp *= 1.1;
          newLvl++;
        }

        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'currentXp': newXp,
          'currentLvl': newLvl,
          'objectiveXp': newObjXp
        });

        setState(() {
          xp = newXp;
          lvl = newLvl;
          objXp = newObjXp;
        });

        getLevel();

        print("XP mis à jour avec succès !");
      } else {
        print('Le document utilisateur n\'existe pas');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'XP : $e');
    }
  }
}

  Future<void> getLevel() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      print('current xp: ${userDoc.data()?['currentXp']}');
      print('objective xp: ${userDoc.data()?['objectiveXp']}');
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

  /// Displays the main title of the screen.
  Widget _title() {
    return Center(
        child: Column(children: [
      Image.asset('assets/images/1Raward.png', width: 200, height: 200),
      Text(
        'Félicitations!',
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 34,
                color: Color(0xfffdfffd))),
      ),
    ]));
  }

  /*
ThreeDSlider(
      cards: Badges.asMap().entries.map((entry) {
          int index = entry.key; 
          String url = entry.value;

          if (index <= widget.stepIndex) {
            return Image.asset(url);
          } else {
            return ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.9), // Applique un filtre noir semi-transparent
                BlendMode.srcATop,
              ),
              child: Image.asset(url),
            );
          }
        }).toList(),
      frameHeight: 300, 
      frameWidth: 165,
      selectedIndex: widget.stepIndex,
      sideFrameOpacity: 1,
      prevButtonIcon: Icon(
        CupertinoIcons.back,
        color: Color(0xfffdfffd),
      ),
      nextButtonIcon: Icon(
        CupertinoIcons.chevron_forward,
        color: Color(0xfffdfffd),
      ),
      ),
  */

  /// Displays the title of the current project step.
  Widget _stepTitle() {
    return Center(
      child: Text(
        stepName,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Color(0xfffdfffd),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
      ),
    );
  }

  Widget _xpAdded() {
    return Text(
      'Gain de ${widget.xpToAdd} xp',
      style: GoogleFonts.sora(textStyle: TextStyle(color: Colors.white)),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SizedBox(
            height: 25,
            child: Progressbar(
              percentageCompletion: (xp / objXp) * 100,
              showPercentage: false,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(
                  text: 'Niveau ',
                  style: GoogleFonts.sora(),
                  children: [
                TextSpan(
                    text: '$lvl',
                    style: GoogleFonts.sora(
                        textStyle: TextStyle(
                            color: Color(0xff9c9790),
                            fontWeight: FontWeight.w700,
                            fontSize: 18))),
                TextSpan(text: ' | ${xp.toStringAsFixed(0)} ', style: GoogleFonts.sora()),
                TextSpan(
                    text: '/ ${objXp.toStringAsFixed(0)}',
                    style: GoogleFonts.sora(
                        textStyle: TextStyle(color: Color(0xff9c9790)))),
              ]))
        ],
      ),
    );
  }

  /// Displays the button to continue to the next screen or step.
  Widget _continueButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: Colors.transparent, // Fond transparent
        shadowColor: Colors.transparent, // Supprime l'ombre
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bordures arrondies
          side: BorderSide(
            color: Color(0xff9c9790), // Bordure blanche teintée
            width: 2, // Épaisseur de la bordure
          ),
        ),
      ),
      child: Text(
        'Continuer',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Color(0xff9c9790), // Texte de la même couleur que la bordure
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _description() {
    return Center(
      child: Text(
        widget.title,
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                color: Color(0xfffdfffd),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
      body: Stack(
        children: [
          /// CONTENU PRINCIPAL CENTRÉ
          Center(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 30), // Centrage horizontal
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centre le contenu verticalement
                children: [
                  _title(),
                  SizedBox(height: 5),
                  _stepTitle(),
                  SizedBox(height: 8),
                  _description(),
                  SizedBox(height: 20),
                  _progressBar(),
                  SizedBox(height: 40),
                  _continueButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
