import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:makeitcode/pages/games/gamePendu/GamePendu.dart';
import 'package:makeitcode/pages/games/projects/glossary_page.dart';
import 'package:makeitcode/pages/games/questionnaire/questionnaire_list_page.dart';
import 'package:makeitcode/pages/games/questionnaire/ranking.dart';
class HomeGamePage extends StatefulWidget {
  @override
  _HomeGamePageState createState() => _HomeGamePageState();
}

class _HomeGamePageState extends State<HomeGamePage> {
  List<dynamic> game = [];

  Future<void> loadGame() async {
    try {
      final String response =
          await rootBundle.loadString('lib/pages/games/game.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        game = data.map((game) {
          return game as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des jeux : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [
      IconButton(
        icon: Icon(Icons.book),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GlossaryPage()),
          );
        },
      ),
    ],
    leading: IconButton(
      icon: Icon(Icons.leaderboard),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClassementPage()),
          );
      },
    ),
        title: Text(
          'Nos Jeux',
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromRGBO(0, 113, 152, 1),
                Color.fromARGB(255, 11, 22, 44),
              ],
              stops: [0.1, 0.9],
              center: Alignment(-0.3, 0.7),
              radius: 0.8,
            ),
          ),
          child: game.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: CarouselSlider.builder(
                        itemCount: game.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.7,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 0.8,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      child: Image.asset(
                                        game[index]['image'],
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      game[index]['title'],
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        game[index]['description'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(11, 153, 253, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    onPressed: () {
                                      Widget page;
                                      switch (game[index]['link']) {
                                        case 'QuestionnaireListPage':
                                          page = QuestionnaireListPage();
                                          break;
                                        case 'GamePenduPage':
                                          page = GamePendu();
                                          break;
                                        default:
                                          page = Container();
                                          break;
                                      }

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => page),
                                      );
                                    },
                                    child: Text("Jouer",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                  ),
                                ],
                              ),
                            ),
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
}
