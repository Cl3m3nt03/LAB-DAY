import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/rewardScreenXp.dart';
import 'package:makeitcode/theme/custom_colors.dart';


class GamePendu extends StatefulWidget {
  @override
  _GamePenduState createState() => _GamePenduState();
}

class _GamePenduState extends State<GamePendu> {
  CustomColors? customColor;
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

  void _Victory() {
    if (selectedWord.split('').every((letter) => guessedLetters.contains(letter))) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RewardscreenXp(xpToAdd: 50, title: 'Vous avez trouvé le mot : $selectedWord !\n\nVous avez gagné 50 xp'),
        ),
      );
    }
    else if (attemptsLeft == 0) {
      print('Perdu !');
    }
  }

  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jeux du Pendu',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 24,
                color: customColor?. white ?? Colors.white),
          ),
        ),
        centerTitle: true,
        iconTheme:  IconThemeData(color: customColor?. white ??Colors.white),
        backgroundColor:  customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
      ),
      body:  SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),
                        customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
                      ],
                      stops: [0.1, 0.9],
                      center: Alignment(-0.7, 0.7),
                      radius: 0.8,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002),
                      Text('Essais restants: $attemptsLeft',
                          style: TextStyle(fontSize: 24, color: customColor?. vibrantBlue ??Color.fromRGBO(11, 153, 253, 1),)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.002),
                      Text(
                        selectedWord
                            .split('')
                            .map((letter) =>
                                guessedLetters.contains(letter) ? letter : '_')
                            .join(' '),
                        style: TextStyle(fontSize: 32, color:const Color.fromARGB(255, 255, 255, 255)),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Wrap(
                        spacing: MediaQuery.of(context).size.width * 1 / 30,
                        runSpacing: 3,
                        alignment: WrapAlignment.center,
                        children: 'abcdefghijklmnopqrstuvwxyz'
                            .split('')
                            .map((letter) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            backgroundColor:
                                customColor?. vibrantBlue ??Color.fromRGBO(11, 153, 253, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            ),
                            onPressed: guessedLetters.contains(letter) ||
                                attemptsLeft == 0
                              ? null
                              : () {
                                guessLetter(letter);
                                _Victory();
                                },
                            child: Text(letter , style: TextStyle(fontSize: 24 , color: Color.fromARGB(255, 255, 255, 255))),
                            );
                        }).toList(),
                      ),
                   
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                customColor?. vibrantBlue ??Color.fromRGBO(11, 153, 253, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        onPressed: startNewGame,
                        child: Text('Nouvelle Partie',
                            style: TextStyle(fontSize: 24 , color:  Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ],
                  ),
                ),
                ),
              ],
            ),
          ),
    );
  }
}
