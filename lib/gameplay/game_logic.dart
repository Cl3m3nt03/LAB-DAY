import 'dart:convert';

import 'package:code_editor/code_editor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makeitcode/widget/style_editor.dart';
import'package:makeitcode/pages/web_view/loadWebView.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/widget/rewardScreen.dart';
import 'package:makeitcode/theme/custom_colors.dart';


class GameLogic extends StatefulWidget {
  final String userId; 
  final int currentStep; // Ajout de currentStep pour la synchronisation des étapes
  final Function(bool) onStepValidated;  // Callback pour incrémenter le niveau


  GameLogic({required this.userId, required this.currentStep, required this.onStepValidated});

  @override
  _GameLogicState createState() => _GameLogicState();
}

class _GameLogicState extends State<GameLogic> {
  CustomColors? customColor;
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

  FocusNode _focusInput1 = FocusNode();
  FocusNode _focusInput2 = FocusNode(); 
  FocusNode _focusInput3 = FocusNode();
    // Récupérer l'utilisateur connecté 

  @override
  void initState() {
    super.initState();
    currentStep = widget.currentStep; // Assurez-vous que currentStep est initialisé correctement
    loadContent(currentStep);
  }

  // Fonction pour charger le fichier JSON et récupérer les données
  Future<void> loadContent(int step) async {
    String jsonString = await rootBundle.loadString('assets/game/html.json');
    List<dynamic> jsonData = json.decode(jsonString);
    User? user = FirebaseAuth.instance.currentUser;

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

    // 🔹 Sauvegarde du niveau actuel du joueur dans Firebase
    await FirebaseFirestore.instance
      .collection('Users')
      .doc(user?.uid)
      .collection('Portfolio')
      .doc('levelMap') // Clé où on enregistre le niveau
      .set({'currentStep': currentStep}, SetOptions(merge: true));
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
      // Appeler le callback pour incrémenter le niveau dans mapLevel
      widget.onStepValidated(_isValid);  // Appelle la fonction callback
      saveUserData(); // Sauvegarder les données dans Firebase
      loadContent(currentStep + 1);

      if (currentStep == 20) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Rewardscreen(
              xpToAdd: 500, // Exemple d'XP à ajouter, vous pouvez le personnaliser
            ),
          ),
      );
    }
    }
  }


Widget buildToolbarButton(String text, TextEditingController controller) {
    customColor = Theme.of(context).extension<CustomColors>();
    return SizedBox(
      width: 120,
      child: GestureDetector(
        onTap: () {
          setState(() {
            controller.text += text;
            _checkAnswer();
          });
        },
        child: Container(
          padding: EdgeInsets.all(9),
          decoration: BoxDecoration(
            border: Border.all(color:  Color.fromARGB(255, 221, 221, 221)),
            borderRadius: BorderRadius.circular(8.0),
            color: Color.fromRGBO(112, 134, 203, 100),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 20.0, color: customColor?.white?? Colors.white,),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
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
      backgroundColor: customColor?.backGameLogic?? const Color(0xFF0B162C),
    appBar: AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.open_in_browser),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebViewPage()),
            );
          },
        ),
      ],
      title: Center( 
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: currentStep / 20.0, // 20.0 force la division à retourner un double
              backgroundColor: Colors.grey.shade700,
              color: customColor?.white?? Colors.white,
              minHeight: 5,
            ),
          ],
        ),
      ),
      backgroundColor: customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),
      foregroundColor: customColor?.white?? Colors.white,
    ),

      body: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          nextFocus: false,
          actions: [
            KeyboardActionsItem(
              focusNode: _focusInput1,
              toolbarButtons: [
                (node) => buildToolbarButton('<', _firstFieldController),
                (node) => buildToolbarButton('>', _firstFieldController),
                (node) => buildToolbarButton('/', _firstFieldController),
              ],
            ),
            KeyboardActionsItem(
              focusNode: _focusInput2,
              toolbarButtons: [
                (node) => buildToolbarButton('<', _lastFieldController),
                (node) => buildToolbarButton('>', _lastFieldController),
                (node) => buildToolbarButton('/', _lastFieldController),
              ],
            ),
            KeyboardActionsItem(
              focusNode: _focusInput3,
              toolbarButtons: [
                (node) => buildToolbarButton('<', _lastFieldController),
                (node) => buildToolbarButton('>', _lastFieldController),
                (node) => buildToolbarButton('/', _lastFieldController),
              ],
            ),
          ],
        ),
       child : Padding(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(104, 191, 199, 237),
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
                  color: customColor?. lightLavender ??Color.fromARGB(255, 191, 199, 237),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: customColor?. dark?? Colors.black,
                          autocorrect: false,      
                          enableSuggestions: false, 
                          textInputAction: TextInputAction.done,
                          focusNode: _focusInput1,
                          controller: _firstFieldController,
                          decoration: InputDecoration(
                            labelText: 'Balise Ouverture',
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: customColor?.dark ?? Colors.black,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure active (quand sélectionné)
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure inactive (par défaut)
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 10,
                            color: customColor?. dark?? Colors.black
                            ),
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
                            cursorColor: customColor?. dark?? Colors.black,
                            autocorrect: false,      
                            enableSuggestions: false, 
                            textInputAction: TextInputAction.done,
                            focusNode: _focusInput2,
                            controller: _secondFieldController, // Ajout du controller
                            decoration: InputDecoration(
                              labelText: 'Insérer votre texte',
                              labelStyle: TextStyle(fontSize: 10, 
                                color: customColor?. dark?? Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure active (quand sélectionné)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure inactive (par défaut)
                              ),
                            ),
                            style: TextStyle(fontSize: 8,
                            color: customColor?. dark?? Colors.black),
                            onChanged: (text) {
                              _checkAnswer();
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          cursorColor: customColor?. dark?? Colors.black,
                          autocorrect: false,      
                          enableSuggestions: false, 
                          textInputAction: TextInputAction.done,
                          focusNode: _focusInput3,
                          controller: _lastFieldController,
                          decoration: InputDecoration(
                            labelText: 'Balise Fermeture',
                            labelStyle: TextStyle(fontSize: 12,
                            color: customColor?. dark?? Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure active (quand sélectionné)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: customColor?.dark ?? Colors.black), // Bordure inactive (par défaut)
                              ),
                          ),
                          style: TextStyle(fontSize: 10,
                            color: customColor?. dark?? Colors.black),
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
              Visibility(
                visible: _isValid, // Affiche le bouton seulement si _isValid est vrai
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _isValid ? () {
                      _nextStep();
                    } : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Color.fromARGB(255, 50, 52, 76),
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
              ), 
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

