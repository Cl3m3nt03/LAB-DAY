import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makeitcode/gameplay/game_logic.dart';
import 'package:rive/rive.dart';

class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> {

late StateMachineController _controller;


  final ScrollController _scrollController = ScrollController();

Timer? _timer;

  SMIInput<double>? levelValue;
  SMIInput<double>? _currentLvlRive;
  int countBeforeSpak = 0;


@override
void initState() {
    super.initState();
}

void _startTimer(SMIInput<bool> toggleSpark){
  _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    _spark(toggleSpark);
  });
}

void _spark(SMIInput<bool> toggleSpark){
  if(countBeforeSpak >= 3){
    countBeforeSpak = 0;
    print('Valeur: $toggleSpark.value');
    toggleSpark.value = true;
  }
  else{
    toggleSpark.value = false;
    countBeforeSpak++;
  }
}

void onInit(Artboard artboard) async {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    print(_controller);
    artboard.addController(_controller);

    SMIInput<bool>? toggleSpark = _controller.findInput<bool>('toggleSpark');

    //double level = event.properties['Level'] as double;
    levelValue = _controller.findInput<double>('currentLvl');
    _currentLvlRive = _controller.findInput<double>('LevelThatIsChanged');
    
    // 🔹 Récupération du niveau depuis Firebase
    int savedStep = await _getSavedStep(); // Récupère la valeur stockée
    levelValue?.value = savedStep.toDouble(); // Affecte à l'animation

    _currentLvlRive?.value = 0;
    print("Test ${levelValue?.value} ${_currentLvlRive?.value}");

    _startTimer(toggleSpark!);

        WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
}

// 🔹 Fonction pour récupérer l'étape enregistrée depuis Firebase
Future<int> _getSavedStep() async {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(user?.uid)
      .collection('Portfolio')
      .doc('levelMap')
      .get();

  if (snapshot.exists && snapshot.data() != null) {
    return snapshot.data()!['currentStep'] ?? 1; // Par défaut : niveau 1
  }
  return 1;
}

void _incrementLevelSync(bool isValid) {
  _incrementLevel(isValid);  // Appel de la version asynchrone
}

Future<void> _incrementLevel(bool isValid) async {
  if (isValid) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // 🔹 Récupère la valeur actuelle et l'incrémente
    int newStep = ((levelValue?.value ?? 1) + 1).toInt();
    if (newStep > 20) {
      newStep = 20; // Limite à 20
    }

    // 🔹 Met à jour dans Firestore
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Portfolio')
        .doc('levelMap')
        .set({'currentStep': newStep}, SetOptions(merge: true));

    // 🔹 Met à jour dans l'animation
    levelValue?.value = newStep.toDouble();
  }
}


void _triggerRiveEvent() async {
  User? user = FirebaseAuth.instance.currentUser;
  print("test3 : ${levelValue?.value} ${_currentLvlRive?.value}");

  if (levelValue?.value == _currentLvlRive?.value) {
    var levelData = await loadLevelData();
    var level = levelData?.firstWhere((stepData) => stepData['step'] == levelValue?.value);

    // Passe la fonction de validation en callback
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameLogic(
          userId: user!.uid,
          currentStep: levelValue!.value.toInt(), 
          onStepValidated: _incrementLevelSync,  // Appelle la version synchrone
        ),
      ),
    );
  } else {
    print("Condition non remplie : levelValue = ${levelValue?.value}, _currentLvlRive = ${_currentLvlRive?.value}");
  }
}



// Fonction pour charger le fichier JSON
Future<List<Map<String, dynamic>>?> loadLevelData() async {
  try {
    // Charge le fichier JSON depuis les assets
    String jsonString = await rootBundle.loadString('assets/game/html.json');
    List<dynamic> jsonList = json.decode(jsonString);

    // Retourne la liste de niveaux sous forme de List<Map<String, dynamic>>
    return jsonList.map((e) => e as Map<String, dynamic>).toList();
  } catch (e) {
    print("Erreur de chargement du fichier JSON: $e");
    return null;
  }
}

// Fonction pour charger un fichier en fonction du nom
Future<void> loadFile(String fileName) async {
  // Implémente la logique pour charger le fichier en fonction de `fileName`
  // Par exemple, tu pourrais utiliser des fichiers stockés localement ou récupérer des données depuis un serveur.
  print("Chargement du fichier correspondant à : $fileName");
}



    @override
    void dispose() {
      _controller.dispose();
      _timer?.cancel();
      super.dispose();
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte interactive avec Rive
          SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: SizedBox(
              height: 2500, // Hauteur suffisante pour scroller
              child: GestureDetector(
                onTap: _triggerRiveEvent, // Déclenchement du clic
                child: RiveAnimation.asset(
                  'assets/rive/levelmap.riv',
                  onInit: onInit,
                ),
              ),
            ),
          ),

          // Bouton de retour en haut à gauche
          Positioned(
            top: 40, // Ajuste la position verticale
            left: 16, // Ajuste la position horizontale
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context); // Retour en arrière
              },
              backgroundColor: Colors.white.withOpacity(0.8), // Fond semi-transparent
              elevation: 3,
              mini: true, // Petit bouton
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


/*Scaffold(
  body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SizedBox(
      height: 1250, // Mets une hauteur plus grande que l'écran pour activer le scroll
      child: RiveAnimation.asset(
        'assets/rive/levelmap.riv',
        onInit: onInit,
      ),
    ),
  ),
);*/