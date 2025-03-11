import 'dart:convert';

import 'package:code_editor/code_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makeitcode/widget/style_editor.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class GameLogic extends StatefulWidget {
  final String userId; // L'ajout de l'identifiant de l'utilisateur

  GameLogic({required this.userId});

  @override
  _GameLogicState createState() => _GameLogicState();
}

class _GameLogicState extends State<GameLogic> {
  String title = "Chargement...";
  String heading = "Chargement...";
  String instruction = "Chargement...";
  String codeContent = "";
  int currentStep = 1; 
  final _firstFieldController = TextEditingController();
  final _secondFieldController = TextEditingController(); // Ajout du controller pour second field
  final _lastFieldController = TextEditingController();
  bool _isValid = false;
  String firstFieldFromJson = "";
  bool secondFieldFromJson = false ; 
  String lastFieldFromJson = "";

  @override
  void initState() {
    super.initState();
    loadContent(currentStep);
  }

  // Fonction pour charger le fichier JSON et récupérer les données
  Future<void> loadContent(int step) async {
    String jsonString = await rootBundle.loadString('assets/game/html.json');
    List<dynamic> jsonData = json.decode(jsonString);

    var stepData = jsonData.firstWhere((element) => element["step"] == step);

    setState(() {
      currentStep = step;
      title = stepData["title"];
      heading = stepData["description"]["heading"];
      instruction = stepData["description"]["instruction"];
      codeContent = stepData["code"];
      firstFieldFromJson = stepData["firstField"]; 
      secondFieldFromJson = stepData["secondField"]; 
      lastFieldFromJson = stepData["lastField"]; 

      // Réinitialisation des champs et du bouton
      _firstFieldController.clear();
      _secondFieldController.clear(); // Réinitialisation du second champ
      _lastFieldController.clear();

      _isValid = false;  // Désactive le bouton à chaque changement d'étape
    });
  }



Future<void> saveUserData() async {
  // Charger le fichier JSON
  String jsonString = await rootBundle.loadString('assets/game/html.json');
  List<dynamic> jsonData = json.decode(jsonString);

  // Récupérer les données de l'étape actuelle
  var stepData = jsonData.firstWhere((element) => element["step"] == currentStep);
  String fieldKey = stepData["bdd"]; // Clé associée (ex: "html_structure", "footer_info", etc.)

  // Récupérer l'utilisateur connecté
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Créer un objet pour stocker la donnée
      Map<String, dynamic> dataToSave = {};

      // Vérifier que la clé n'est pas vide et associer la valeur saisie par l'utilisateur
      if (fieldKey.isNotEmpty) {
        dataToSave[fieldKey] = _secondFieldController.text.trim();
      }

      // Sauvegarder les données dans Firebase
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Portfolio')
          .doc('data')
          .set(dataToSave, SetOptions(merge: true)); // Merge pour ne pas écraser d'autres données existantes

      print('Données sauvegardées dans Firebase avec l\'UID : ${user.uid}');
    } catch (e) {
      print("Erreur lors de l'enregistrement des données : $e");
    }
  } else {
    print("Aucun utilisateur connecté.");
  }
}


  // Vérifie si les champs saisis par l'utilisateur sont corrects
  void _checkAnswer() {
    setState(() {
      _isValid = _firstFieldController.text.trim() == firstFieldFromJson &&
                 _lastFieldController.text.trim() == lastFieldFromJson;
    });
  }

  void _nextStep() {
    if (_isValid) {
      // Lancer la fonction pour charger l'étape suivante
      saveUserData(); // Sauvegarder les données dans Firebase
      loadContent(currentStep + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = EditorModel(
      files: [
        FileEditor(
          name: "index.html",
          language: "html",
          code: codeContent,
          readonly: true,
        ),
      ],
      styleOptions: EditorModelStyleOptions(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B162C),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: currentStep / 20, // Mise à jour dynamique
              backgroundColor: Colors.grey.shade700,
              color: Colors.white,
              minHeight: 5,
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(0, 113, 152, 1), // Bleu foncé
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(104, 191, 199, 237),
                  borderRadius: BorderRadius.circular(4),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lavenderMist, // Violet foncé
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      instruction,
                      style: TextStyle(fontSize: 16, color: lilacDream),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(6),
                width: double.infinity,
                child: CodeEditor(
                  model: code,
                  disableNavigationbar: false,
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 191, 199, 237),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstFieldController,
                          decoration: InputDecoration(
                            labelText: 'Balise Ouverture',
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                          style: TextStyle(fontSize: 10),
                          onChanged: (text) {
                            _checkAnswer();
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Visibility(
                        visible: secondFieldFromJson, // Utilise la variable de state
                        child: Expanded(
                          child: TextField(
                            controller: _secondFieldController, // Ajout du controller
                            decoration: InputDecoration(
                              labelText: 'Insérer votre texte',
                              labelStyle: TextStyle(fontSize: 10),
                            ),
                            style: TextStyle(fontSize: 8),
                            onChanged: (text) {
                              _checkAnswer();
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _lastFieldController,
                          decoration: InputDecoration(
                            labelText: 'Balise Fermeture',
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                          style: TextStyle(fontSize: 10),
                          onChanged: (text) {
                            _checkAnswer();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _isValid ? () {
                    _nextStep();
                  } : null, // Désactive le bouton si la réponse est incorrecte
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 50, 52, 76),
                    backgroundColor: const Color.fromARGB(255, 222, 226, 255),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONFIRMER',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

