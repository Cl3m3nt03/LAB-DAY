import 'package:flutter/material.dart';
import 'package:makeitcode/pages/questionnaire/questionnaire.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:makeitcode/widget/customRadioTile.dart';
import 'package:makeitcode/pages/questionnaire/ranking.dart';
import 'package:google_fonts/google_fonts.dart';

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
      final String response = await rootBundle.loadString('lib/pages/questionnaire/list_questionnaire/list_questionnaire.json');
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
      
    void onButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassementPage()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
        onPressed: onButtonPressed,
        tooltip: 'Classement',
        child: const Icon(Icons.emoji_events),
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