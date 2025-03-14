import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:three_d_slider/three_d_slider.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


/// Screen that displays the user's progress, step details, and rewards for a project.
class Rewardscreen extends StatefulWidget {
  final int stepIndex;
  final int xpToAdd;
  const Rewardscreen({super.key, required this.stepIndex, required this.xpToAdd});

  @override
  State<Rewardscreen> createState() => _RewardscreenState();

  static void updateXp(int i) {}
}

/// Manages the state of the Rewardscreen, including level, XP, and project step details.
class _RewardscreenState extends State<Rewardscreen> {

  int lvl = 0;
  int xp = 0;
  int objXp = 100;

  String stepName = ""; 
  String stepDesc = "";

  @override
  /// Initializes user level and step data when the screen is loaded.
  void initState(){
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
        int currentXp = userDoc.data()?['currentXp'] ?? 0;
        int currentLvl = userDoc.data()?['currentLvl'] ?? 0;

        int newXp = currentXp + widget.xpToAdd;
        int newLvl = currentLvl;
        int newObjXp = userDoc.data()?['objectiveXp'] ?? 0;


        if(newXp >= objXp){
          newXp -= objXp;
          newObjXp *= 2;
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
          xp = userDoc.data()?['currentXp'] ?? 0; 
          objXp = userDoc.data()?['objectiveXp'] ?? 100; 
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
  Widget _title(){
    return Center(
      child: Text(
        'Félicitations!',
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 34,
            color: Color(0xfffdfffd)
          )
        ),
      ),
    );
  }
  /// Displays the subtitle with the unlocked level.
  Widget _subTitle(){
    return Center(
      child: Text(
        'Etape ${widget.stepIndex +1} débloqué',
        style: GoogleFonts.sora(
          textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color(0xffd4b394)
          )
        ),
      ),
    );
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
  Widget _stepTitle(){
    return Center(
      child: Text(
        stepName,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Color(0xfffdfffd),
            fontWeight: FontWeight.w600,
            fontSize: 18
          )
        ),
      ),
    );
  }

  /// Displays the description of the current project step.
  Widget _stepDesc(){
    return Center(
      child: Text(
        stepDesc,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: Color(0xffcad0cf).withOpacity(0.8),
            fontWeight: FontWeight.w400,
            fontSize: 15
          )
        ),
      ),
    );
  }


  Widget _xpAdded(){
    return Text(
      'Gain de $xp xp',
      style: GoogleFonts.sora(
        textStyle: TextStyle(
          color: Colors.white
        )
      ),
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
            percentageCompletion: (xp/objXp)*100,
            showPercentage: false,
          ),
        ),
        SizedBox(height: 10,),
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
                    fontSize: 18
                  )
                )
              ),
              TextSpan(
                text: ' | $xp ',
                style: GoogleFonts.sora()
              ),
              TextSpan(
                text: '/ $objXp',
                style: GoogleFonts.sora(
                  textStyle: TextStyle(
                    color: Color(0xff9c9790)
                  )
                )
              ),
            ]
          )
        )
      ],
    ),
  );
}

/// Displays the button to continue to the next screen or step.
Widget _continueButton(){
  return ElevatedButton(
    onPressed: () {},
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

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 11, 22, 44),
    body: Stack(
      children: [
        /// CONTENU PRINCIPAL CENTRÉ
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30), // Centrage horizontal
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu verticalement
              children: [
                _title(),
                SizedBox(height: 10),
                _subTitle(),
                SizedBox(height: 20),
                _stepTitle(),
                SizedBox(height: 8),
                _stepDesc(),
                _xpAdded(),
                SizedBox(height: 10),
                _progressBar(),
                SizedBox(height: 40),
                _continueButton(),
              ],
            ),
          ),
        ),

        /// BOUTON RETOUR POSITIONNÉ EN HAUT À DROITE
        Positioned(
          top: 40,  
          right: 20, 
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); 
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Color(0xffd4b394)),
                color: Colors.transparent, 
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                CupertinoIcons.clear,
                size: 24,
                color: Color(0xffd4b394),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


}