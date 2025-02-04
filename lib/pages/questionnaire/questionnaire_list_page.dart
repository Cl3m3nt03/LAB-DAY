import 'package:flutter/material.dart';
import 'package:makeitcode/pages/questionnaire/questionnaire.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:makeitcode/widget/customRadioTile.dart';
import 'package:audioplayers/audioplayers.dart';

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

    Future<void> loadQuestions() async {
    try {
      final String response = await rootBundle.loadString('lib/games/questionnaire/list_questionnaire/list_questionnaire.json');
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



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      title: Text("Questionnaires", style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 11, 22, 44),
    ),
      body: Container(
        color: const Color.fromARGB(255, 11, 22, 44),
        child : 
      Builder(builder: (context) {
        return ListView.builder(
          itemCount: questionnaire.length,
          itemBuilder: (context, index) {
            return Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: 
            Card(
              color: Colors.blue,
              child:
            ListTile(
              title: Text(questionnaire[index]['title'], style:  TextStyle(fontSize: 20, color: Colors.white)),
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