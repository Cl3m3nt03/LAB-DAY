import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:makeitcode/widget/customRadioTile.dart';
import 'package:audioplayers/audioplayers.dart';


class QuestionnairePage extends StatefulWidget {
  final String questionnaireName;
  final String title;
  String validationMessage = '';
  bool showValidationMessage = false;

  QuestionnairePage({Key? key, required this.questionnaireName, required this.title}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> with SingleTickerProviderStateMixin {
  List<dynamic> questions = [];
  int actuallyquestion = 0;
  int score = 0;
  bool error = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), 
      end: const Offset(0, 0), 
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );
    loadQuestions(widget.questionnaireName);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Future<void> loadQuestions(String questionnaireName) async {
    try {
      final String response = await rootBundle.loadString(questionnaireName);
      final List<dynamic> data = json.decode(response);
      setState(() {
        data.shuffle(Random());
        questions = data.take(20).map((question) {
          question['selected'] = question['selected'] ?? -1;
          return question;
        }).toList();
        for (var question in questions) {
          print(question['question']);
        }
        });
    } catch (e) {
      print('Erreur lors du chargement des questions : $e');
    }
  }

  Widget submitAnswer(Map<String, dynamic> question) {
    return Container(
      width: double.infinity,
      height: error ? 210 : 100.0,
      color: const Color.fromARGB(255, 11, 22, 44),
      child: Column(
        children: [
          Spacer() ,
          SlideTransition(
            position: _slideAnimation,
            child: error
                ? Container(
                    color: const Color.fromARGB(255, 30, 40, 60),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.close,
                              color: Color.fromARGB(255, 220, 53, 69),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.validationMessage,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 220, 53, 69),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          question['explication']['text'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 220, 53, 69),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 25),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: TextButton(
              style: question['selected'] == -1
                  ? TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 105, 135),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  : TextButton.styleFrom(
                      backgroundColor: error
                          ? const Color.fromARGB(255, 220, 53, 69)
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
              onPressed: () {
                if (question['selected'] == -1) {
                } else if (error) {
                  setState(() {
                    widget.showValidationMessage = false;
                    error = false;
                  });
                  nextQuestion();
                } else {
                  validateAnswer();
                }
              },
              child: Text(
                error ? 'Continuer' : 'Valider',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void validateAnswer() {
    final question = questions[actuallyquestion];
    setState(() {
      if (question['selected'] == question['solved']) {
        score += 1;
        error = false;
        final player = AudioPlayer();
        player.play(AssetSource('sound/correct.wav'));
        nextQuestion();
      } else {
        final player = AudioPlayer();
        player.play(AssetSource('sound/incorrect.wav'));
        error = true;
        widget.validationMessage = 'Incorrect';
        _animationController.forward();
      }
    });
  }
  void nextQuestion() {
    setState(() {
      if (actuallyquestion < questions.length - 1) {
        actuallyquestion += 1;
        _animationController.reverse(); 
      }
      else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 11, 22, 44),
                title: const Text('HTML CSS', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Score : $score / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Retour'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    });
  }
    Widget progressIndicatorRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: actuallyquestion / questions.length,
          minHeight: 10,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }

Widget buildQuestionCard() {
  final question = questions[actuallyquestion];
  final options = question['options'] ?? [];
  return Container(
    child: Card(
      color: Color.fromARGB(255, 11, 22, 44),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            progressIndicatorRow(context),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                question['question'] ?? 'Question non chargée',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, optionIndex) {
                  final option = options[optionIndex];
                  return CustomRadioTile(
                    error: error,
                    selected: question['solved'],
                    title: option['text'],
                    value: optionIndex,
                    groupValue: question['selected'] ?? -1,
                    onChanged:error ? (value) {
                      setState(() {
                        null;
                      });
                    }: (value) {
                      setState(() {
                        question['selected'] = value;
                      });
                    },
                  );
            },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 11, 22, 44),
          title: const Text('Questionnaire', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 22, 44),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              '${actuallyquestion + 1} / ${questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 11, 22, 44),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                buildQuestionCard(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: submitAnswer(questions[actuallyquestion]),
          ),
        ],
      ),
    );
  }
}
