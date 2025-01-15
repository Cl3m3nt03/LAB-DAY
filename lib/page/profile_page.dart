import 'package:flutter/material.dart';
import 'package:makeitcode/page/editprofile_page.dart';
import 'package:makeitcode/page/securite_page.dart';
import 'package:makeitcode/page/settings_page.dart';
import 'package:makeitcode/widget/textField.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Color.fromRGBO(0, 113, 152, 1),Color.fromARGB(255, 11, 22, 44)], 
                stops: [0.2, 0.9],
                begin: Alignment.topCenter,
                end: Alignment.center, 

                ),
                ),
              child:  SingleChildScrollView(
                child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width -40,
                      decoration:BoxDecoration(
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
                            Text("Profile", style: TextStyle(color: Color.fromARGB(250, 175, 142, 88), fontSize: 20, ),),
                           Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/icons/baka.png'),
                              ),
                              Column(
                                children: [
                                  Text('Clément Hanji', style: TextStyle(color: Colors.white, fontSize: 15),),
                                  Text('+33 6 52 54 52 45', style: TextStyle(color: Color.fromRGBO(145, 141, 141, 1), fontSize: 15),),
                                ],
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(250, 175, 142, 88)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () { },
                                child: Text('Edit Profile', style: TextStyle(color: Colors.white , fontSize: 10),),
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
                            width: MediaQuery.of(context).size.width -50,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(24, 37, 63, 0.4),
                            ),
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.person , color: Colors.white,),
                                      TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  EditCompte()),
                                      );
                                    },
                                    child: const Text("Mon Compte", style: TextStyle(color: Colors.white),),
                                  )
                                    ],
                                  ),
                                ),
                                Divider(color: const Color.fromARGB(70, 255, 255, 255)),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.key, color: Colors.white),
                                      SizedBox(width: 5),
                                      TextButton(
                                      onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  SecuritePage()),
                                      );
                                    },
                                    child: const Text("Sécurité", style: TextStyle(color: Colors.white),),
                                  )
                                    ],
                                  ),
                                ),
                                Divider(color: const Color.fromARGB(70, 255, 255, 255)),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.white),
                                      SizedBox(width: 5),
                                      TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>  SettingsPage()),
                                      );
                                    },
                                    child: const Text("Réglages", style: TextStyle(color: Colors.white),),
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
                            width: MediaQuery.of(context).size.width -50,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(24, 37, 63, 0.4),
                            ),
                            child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.white),
                                      SizedBox(width: 15), 
                                      Text(
                                        "Politique de confidentialité",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Divider(color: const Color.fromARGB(70, 255, 255, 255)),
                                SizedBox(height: 20), 
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.contact_mail, color: Colors.white), 
                                      SizedBox(width: 15),
                                      Text(
                                        "Contactez-nous",
                                        style: TextStyle(color: Colors.white),
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
                            width: MediaQuery.of(context).size.width -50,
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromRGBO(24, 37, 63, 0.4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.key, color: Colors.white),
                                  SizedBox(width: 15),
                                  Text("About", style: TextStyle(color: Colors.white)),
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