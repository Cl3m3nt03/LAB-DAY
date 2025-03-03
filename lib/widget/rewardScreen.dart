import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:three_d_slider/three_d_slider.dart';
import 'package:makeitcode/widget/progressBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


/// Screen that displays the user's progress, step details, and rewards for a project.
class Rewardscreen extends StatefulWidget {
  final int stepIndex;
  final Map<String, dynamic> projet;
  const Rewardscreen({super.key, required this.stepIndex, required this.projet});

  @override
  State<Rewardscreen> createState() => _RewardscreenState();
}

/// Manages the state of the Rewardscreen, including level, XP, and project step details.
class _RewardscreenState extends State<Rewardscreen> {

  int lvl = 0;
  int xp = 90;
  int objXp = 100;

  String stepName = ""; 
  String stepDesc = "";

  var Badges = ["assets/icons/BronzeMedal.png", "assets/icons/SilverMedal.png", "assets/icons/GoldMedal.png"];

  @override
  /// Initializes user level and step data when the screen is loaded.
  void initState(){
      super.initState();
      getLevel();
      getStepByIndex();
  }

  /// Fetches the current user level and XP from Firestore.
  Future<void> getLevel() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String uid = user.uid;

    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      print(userDoc.data()?['currentLvl']);
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

/// Retrieves the step details from Firestore based on the provided step index.
Future<void> getStepByIndex() async {
  try {
    final projectId = widget.projet['id'];

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Projects')
        .doc(projectId)
        .collection('Steps')
        .get(); 

    if (querySnapshot.docs.length > widget.stepIndex) {
      final stepDoc = querySnapshot.docs[widget.stepIndex -1];
      final stepData = stepDoc.data();
    

      setState(() {
        stepName = stepData['name'] ?? "Nom non trouvé";
        stepDesc = stepData['desc'] ?? "Description non trouvée";
      });
    } else {
      stepName = "Aucune étape trouvée";
    }
  } catch (e) {
    stepName = "❌ Erreur lors de la récupération du document : $e";
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
        'Niveau 2 débloqués',
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

  /// Displays the 3D slider with badges for the progress.
  Widget _slider(){
    return Center(
      child: ThreeDSlider(
      cards: Badges.map((url) => Image.asset(url)).toList(),
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
    );
  }

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

/// Displays the progress bar indicating the user's current progress.
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

/// Builds the entire rewards screen, including the scrollable content and back button.
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 11, 22, 44),
    body: Stack(
      children: [
        /// CONTENU PRINCIPAL SCROLLABLE
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              SizedBox(height: 60), // Espace pour le bouton retour
              _title(),
              _subTitle(),
              _slider(),
              _stepTitle(),
              SizedBox(height: 8),
              _stepDesc(),
              SizedBox(height: 40),
              _progressBar(),
              SizedBox(height: 45),
              _continueButton(),
            ],
          ),
        ),

        /// BOUTON RETOUR POSITIONNÉ EN HAUT À DROITE
        Positioned(
          top: 40,  // Ajusté pour éviter un chevauchement avec l'encoche
          right: 20, // Meilleur placement
          child: GestureDetector(  // Utilisation de GestureDetector pour éviter tout conflit
            onTap: () {
              Navigator.of(context).pop(); // Retour en arrière
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Color(0xffd4b394)),
                color: Colors.transparent, // Vérification que le fond ne bloque pas
              ),
              padding: EdgeInsets.all(6), // Ajoute du padding pour une meilleure interaction
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