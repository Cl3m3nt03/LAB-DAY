import 'package:flutter/material.dart';
import 'package:makeitcode/pages/games/questionnaire/questionnaire.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:makeitcode/widget/customRadioTile.dart';
import 'package:makeitcode/pages/games/projects/glossary_page.dart';

import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying the list of questionnaires with their details.

class QuestionnaireListPage extends StatefulWidget {
  QuestionnaireListPage({Key? key}) : super(key: key);

  @override
  _QuestionnaireListPageState createState() => _QuestionnaireListPageState();
}

class _QuestionnaireListPageState extends State<QuestionnaireListPage> {
  List<dynamic> questionnaire = [];
  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  /// Loads the list of questionnaires from a JSON file and updates the state.
  Future<void> loadQuestions() async {
    try {
      final String response = await rootBundle.loadString(
          'lib/pages/games/questionnaire/list_questionnaire/list_questionnaire.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        questionnaire = data.map((questionnaire) {
          return questionnaire as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des questions : $e');
    }
  }

  /// Navigates to the ranking page when the button is pressed.

  /// Builds the UI for displaying the list of questionnaires, including a floating action button and app bar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QUESTIONNAIRE',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 11, 22, 44),
      ),
      body: Container(
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
        child: Builder(builder: (context) {
          return ListView.builder(
            itemCount: questionnaire.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(24, 37, 63, 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      questionnaire[index]['title'],
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      "20 Questions",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        questionnaire[index]['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnairePage(
                              questionnaireName: questionnaire[index]['link'],
                              title: questionnaire[index]['title']),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
