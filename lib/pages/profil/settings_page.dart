import 'package:flutter/material.dart';
import 'package:makeitcode/widget/MenuItem.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool light = true;
  bool light1 = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 113, 152, 1),
                    Color.fromARGB(255, 11, 22, 44),
                  ],
                  stops: [0.1, 0.9],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: Color.fromARGB(250, 175, 142, 88),
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  thickness: 1.5,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          left: MediaQuery.of(context).size.width / 2 - 65,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/icons/baka.png'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 110),
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
                                          color: Color.fromARGB(250, 175, 142, 88),
                                        ),
                                        SizedBox(width: 10),
                                        Text("Activer le mode sombre",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            )),
                                        SizedBox(width: 10),
                                        Switch(
                                          value: light,
                                          activeColor: Color.fromARGB(250, 175, 142, 88),
                                          onChanged: (bool value) {
                                            setState(() {
                                              light = value; 
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                Divider(color: const Color.fromARGB(70, 255, 255, 255)),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        color: Color.fromARGB(250, 175, 142, 88),
                                      ),
                                      SizedBox(width: 10),
                                      Text("Activer les notifications",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                      SizedBox(width: 10),
                                      Switch(
                                        value: light1,
                                        activeColor: Color.fromARGB(250, 175, 142, 88),
                                        onChanged: (bool value) {
                                          setState(() {
                                            light1 = value; 
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: const Color.fromARGB(70, 255, 255, 255)),
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                              Icons.language,
                                              color: Color.fromARGB(250, 175, 142, 88),
                                            ),
                                            SizedBox(width: 10),
                                            Text("Langue",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                )),
                                            SizedBox(width: MediaQuery.of(context).size.width - 220),
                                            popoverMenu(),
                                            ],
                                          ) 
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
          ],
        ),
      ),
    );
  }
}
