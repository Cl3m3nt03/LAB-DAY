import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/widget/MenuItem.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/widget/notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Boolean to control dark mode
  bool light = true;
  // Boolean to control notifications
  bool light1 = true;

  void _loadDarkMode() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          light = userDoc.data()?['darkmode'] ?? false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Paramètres',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
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
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1.5,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width - 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(116, 24, 37, 63),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.light_mode,
                                            color: Color.fromARGB(
                                                250, 175, 142, 88),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Activer le mode sombre",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Switch(
                                            value: light,
                                            activeColor: Color.fromARGB(
                                                250, 175, 142, 88),
                                            onChanged: (bool value) async {
                                              User? user = FirebaseAuth
                                                  .instance.currentUser;
                                              if (user != null) {
                                                String uid = user.uid;
                                                final userDoc =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Users')
                                                        .doc(uid)
                                                        .get();

                                                NotificationService.init();
                                                NotificationService
                                                    .showInstantNotification(
                                                  "Notification",
                                                  "Vous avez changé de mode",
                                                );

                                                setState(() {
                                                  light = value;
                                                });

                                                if (light) {
                                                  FirebaseFirestore.instance
                                                      .collection('Users')
                                                      .doc(uid)
                                                      .update(
                                                          {'darkmode': true});
                                                } else {
                                                  FirebaseFirestore.instance
                                                      .collection('Users')
                                                      .doc(uid)
                                                      .update(
                                                          {'darkmode': false});
                                                }
                                              }
                                            },
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
                                          Icon(
                                            Icons.notifications,
                                            color: Color.fromARGB(
                                                250, 175, 142, 88),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Activer les notifications",
                                            style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Switch(
                                            value: light1,
                                            activeColor: Color.fromARGB(
                                                250, 175, 142, 88),
                                            onChanged: (bool value) {
                                              setState(() {
                                                light1 = value;
                                                if (light1) {
                                                  NotificationService.init();
                                                  NotificationService
                                                      .showInstantNotification(
                                                          "Notification",
                                                          "Vous avez activé les notifications");
                                                } else {}
                                              });
                                            },
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
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.language,
                                                    color: Color.fromARGB(
                                                        250, 175, 142, 88),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Langue",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              220),
                                                  popoverMenu(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
    );
  }
}
