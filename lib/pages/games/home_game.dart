import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:makeitcode/pages/games/gamePendu/GamePendu.dart';
import 'package:makeitcode/pages/games/projects/glossary_page.dart';
import 'package:makeitcode/pages/games/questionnaire/questionnaire_list_page.dart';
import 'package:makeitcode/pages/games/questionnaire/ranking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/theme/custom_colors.dart';
class HomeGamePage extends StatefulWidget {
  @override
  _HomeGamePageState createState() => _HomeGamePageState();
}

class _HomeGamePageState extends State<HomeGamePage> {
  CustomColors? customColor;
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
    customColor = Theme.of(context).extension<CustomColors>();
    return Scaffold(
      appBar: AppBar(
      actions: [
      IconButton(
        icon: Icon(Icons.book, color: customColor?.white ?? Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GlossaryPage()),
          );
        },
      ),
    ],
    leading: IconButton(
      icon: Icon(Icons.leaderboard,color: customColor?.white ?? Colors.white),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClassementPage()),
          );
      },
    ),
        title: Text(
          'NOS JEUX',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                color: customColor?.white ?? Colors.white),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:  customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),
                customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
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
                                            fontWeight: FontWeight.bold,color: Colors.black,),
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
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                           customColor?.vibrantBlue ??Color.fromRGBO(11, 153, 253, 1),
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
