import 'package:flutter/material.dart';
import 'package:makeitcode/pages/games/questionnaire/questionnaire.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:makeitcode/widget/customRadioTile.dart';
import 'package:makeitcode/pages/games/questionnaire/ranking.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying the list of questionnaires with their details.

class QuestionnaireListPage extends StatefulWidget {

  QuestionnaireListPage ({Key? key}) : super(key: key);

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
      final String response = await rootBundle.loadString('lib/pages/games/questionnaire/list_questionnaire/list_questionnaire.json');
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
    void onButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassementPage()),
    );
  }
  /// Builds the UI for displaying the list of questionnaires, including a floating action button and app bar.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        onPressed: onButtonPressed,
        backgroundColor: Color.fromARGB(255, 209, 223, 255),
        foregroundColor: Color(0xFF5E4F73),
        tooltip: 'Classement',
        child: const Icon(Icons.emoji_events, size: 30,),
      ), 
      appBar: AppBar(
      title: Text('QUESTIONNAIRE',style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),),),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 11, 22, 44),
      
    ),
      body:Container(
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
        child : 
      Builder(builder: (context) {
        /// Displays a list of questionnaires dynamically, each with a title, image, and a link to the detailed questionnaire page.
        return ListView.builder(
          itemCount: questionnaire.length,
          itemBuilder: (context, index) {
            return Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: 
            Card(
              color: Colors.blue,
              child:
            ListTile(
              title: Text(questionnaire[index]['title'], style: GoogleFonts.montserrat(textStyle:TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.white)),),
              subtitle: Text("10 / 100", style: TextStyle(color: Colors.white),),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Image.asset(questionnaire[index]['image']),
                ),
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionnairePage(questionnaireName: questionnaire[index]['link'], title : questionnaire[index]['title']),
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