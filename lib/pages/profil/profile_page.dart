import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:makeitcode/pages/profil/Politique_page.dart';
import 'package:makeitcode/pages/profil/contacte_page.dart';
import 'package:makeitcode/pages/profil/editprofile_page.dart';
import 'package:makeitcode/pages/profil/securite_page.dart';
import 'package:makeitcode/pages/profil/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String> getUserPseudo(String uid) async {
  final userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  if (userDoc.exists) {
    return userDoc.data()?['pseudo'] ?? 'No pseudo found';
  }
  return 'No pseudo found';
}

Future<Uint8List?> getUserAvatar(String uid) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userDoc.exists) {
      return base64Decode(userDoc['avatar']);
    }
  } catch (e) {
    print("Erreur lors de la récupération de l'avatar : $e");
  }
  return null;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _avatarImage;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    String? uid = Auth().currentUser?.uid;
    if (uid != null) {
      Uint8List? avatar = await getUserAvatar(uid);
      setState(() {
        _avatarImage = avatar;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: const Color.fromRGBO(24, 37, 63, 0.4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Profile",
                                  style: GoogleFonts.montserrat(textStyle:TextStyle(
                                    color: Color.fromARGB(250, 175, 142, 88),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: _avatarImage != null
                                        ? MemoryImage(_avatarImage!)
                                        : AssetImage('assets/icons/logo.png')
                                            as ImageProvider,
                                  ),
                                  Column(
                                    children: [
                                      FutureBuilder<String>(
                                        future: getUserPseudo(
                                            Auth().currentUser?.uid ?? ''),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}',
                                                style: TextStyle(
                                                    color: Colors.white));
                                          } else {
                                            return Text(
                                                snapshot.data ??
                                                    'No pseudo available',
                                                style: GoogleFonts.montserrat(textStyle:TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  250, 175, 142, 88)),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditCompte()),
                                      );
                                    },
                                    child: Text(
                                      'Edit Profile',
                                      style: GoogleFonts.montserrat(textStyle:TextStyle(
                                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 216,
                                width: MediaQuery.of(context).size.width - 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromRGBO(24, 37, 63, 0.4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.person,
                                                color: Colors.white),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditCompte()),
                                                );
                                              },
                                              child:  Text(
                                                "Mon Compte",
                                                style:GoogleFonts.montserrat(textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: const Color.fromARGB(
                                              70, 255, 255, 255)),
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.key,
                                                color: Colors.white),
                                            SizedBox(width: 5),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SecuritePage()),
                                                );
                                              },
                                              child:  Text(
                                                "Sécurité",
                                                style:GoogleFonts.montserrat(textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: const Color.fromARGB(
                                              70, 255, 255, 255)),
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.settings,
                                                color: Colors.white),
                                            SizedBox(width: 5),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SettingsPage()),
                                                );
                                              },
                                              child: Text(
                                                "Réglages",
                                                style:GoogleFonts.montserrat(textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              Container(
                                height: 160,
                                width: MediaQuery.of(context).size.width - 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromRGBO(24, 37, 63, 0.4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.policy,
                                                color: Colors.white),
                                            SizedBox(width: 10),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrivacyPolicyPage()),
                                                );
                                              },
                                              child: Text(
                                                "Politique de confidentialité",
                                                style:GoogleFonts.montserrat(textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: const Color.fromARGB(
                                              70, 255, 255, 255)),
                                      Container(
                                        child: Row(
                                          children: [
                                            Icon(Icons.contact_mail,
                                                color: Colors.white),
                                            SizedBox(width: 15),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ContactePage()),
                                                );
                                              },
                                              child: Text(
                                                "Contactez-nous",
                                                style:GoogleFonts.montserrat(textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width - 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromRGBO(24, 37, 63, 0.4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.key, color: Colors.white),
                                      SizedBox(width: 15),
                                      Text("About",
                                      style:GoogleFonts.montserrat(textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 100),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
