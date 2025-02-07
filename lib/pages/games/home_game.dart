import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
          height: MediaQuery.of(context).size.height,
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
              : CarouselSlider.builder(
                  itemCount: game.length,
                  options: CarouselOptions(
                    height: 550,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.8,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                game[index]['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              game[index]['title'],
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Divider(
                              color: const Color.fromARGB(255, 119, 119, 119),
                              thickness: 1,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(11, 152, 253, 1),
                            ),
                            onPressed: () {
                              // Action à faire en cliquant sur "Jouer"
                            },
                            child: Text(
                              "Jouer",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
