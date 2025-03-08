import 'package:flutter/material.dart';

class GamePendu extends StatefulWidget {
  @override
  _GamePenduState createState() => _GamePenduState();
}

class _GamePenduState extends State<GamePendu> {
  final List<String> words = [
    "variable",
    "fonction",
    "classe",
    "objet",
    "boucle",
    "tableau",
    "condition",
    "compilation",
    "algorithme",
    "debug"
  ];
  late String selectedWord;
  late List<String> guessedLetters;
  late int attemptsLeft;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      words.shuffle();
      selectedWord = words.first;
      guessedLetters = [];
      attemptsLeft = 6;
    });
  }

  void guessLetter(String letter) {
    setState(() {
      if (!guessedLetters.contains(letter)) {
        guessedLetters.add(letter);
        if (!selectedWord.contains(letter)) {
          attemptsLeft--;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1),
                      Text('Essais restants: $attemptsLeft',
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      SizedBox(height: 10),
                      Text(
                        selectedWord
                            .split('')
                            .map((letter) =>
                                guessedLetters.contains(letter) ? letter : '_')
                            .join(' '),
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 8,
                        children: 'abcdefghijklmnopqrstuvwxyz'
                            .split('')
                            .map((letter) {
                          return ElevatedButton(
                            onPressed: guessedLetters.contains(letter) ||
                                    attemptsLeft == 0
                                ? null
                                : () => guessLetter(letter),
                            child: Text(letter),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      if (attemptsLeft == 0)
                        Text('Perdu ! Le mot était: $selectedWord',
                            style: TextStyle(fontSize: 24, color: Colors.red)),
                      if (selectedWord
                          .split('')
                          .every((letter) => guessedLetters.contains(letter)))
                        Text('Bravo ! Vous avez trouvé le mot !',
                            style:
                                TextStyle(fontSize: 24, color: Colors.green)),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: startNewGame,
                        child: Text('Nouvelle Partie'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
