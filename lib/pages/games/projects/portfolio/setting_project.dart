import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:makeitcode/pages/web_view/loadDataAndTemplate.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingProjectPage extends StatefulWidget {
  @override
  _SettingProjectPageState createState() => _SettingProjectPageState();
}

class _SettingProjectPageState extends State<SettingProjectPage> {

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final loadDataAndTemplate _dataAndTemplate = loadDataAndTemplate();
    final ToastMessage toast = ToastMessage();
    List<dynamic> theme = [];
    
    Future<void> loadTheme() async {
    try {
      final String response =
          await rootBundle.loadString('lib/pages/games/projects/portfolio/theme.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        theme = data.map((theme) {
          return theme as Map<String, dynamic>;
        }).toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des thémes : $e');
    }
  }

    Future<String> getHtmlFilePath(String templateName) async {
    final Directory? dir = await getExternalStorageDirectory();
    if (dir == null) {
      throw Exception("External storage directory not found");
    }
    return '${dir.path}/$templateName';
  }

    Future<void> _setThemeBdd(link) async {
    final firestoreInstance = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    final docRef = firestoreInstance.collection('Users').doc(uid).collection('Portfolio').doc('data');
    docRef.update({
      "css": link,
    }).then((_) {
      toast.showToast(context, "Thème mis à jour avec succès !");
    });
  }

    @override
  void initState() {
    super.initState();
    loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
        title: Text(
          'Paramètres',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
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
                    child: theme.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Text(
                      'Choisissez un thème',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                         CarouselSlider.builder(
                        itemCount: theme.length,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.6,
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
                                        theme[index]['image'],
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      theme[index]['title'],
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                      _setThemeBdd(theme[index]['link']);
                                    },
                                    child: Text("Choisir ce thème",
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
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      'Télécharger le projet',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(11, 153, 253, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                         _dataAndTemplate.generateHTMLFromFirestore(userId, 'index.html', true);
                             getHtmlFilePath('index.html').then((filePath) {
                               OpenFilex.open(filePath);
                             });
                             toast.showToast(context, "Téléchargement du projet...");
                      },
                      child: Text("Télécharger le projet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
