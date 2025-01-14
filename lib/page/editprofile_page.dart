import 'package:flutter/material.dart';
import 'package:makeitcode/page/profile_page.dart';
import 'package:makeitcode/widget/textField.dart';

class EditCompte extends StatelessWidget {
   EditCompte({super.key});

  final TextEditingController EditPrenomController = TextEditingController();
  final TextEditingController EditNomController = TextEditingController();
  final TextEditingController EditNumberController = TextEditingController();

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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()),
                                      );
                                    },
                                    icon: Icon(Icons.arrow_back_ios,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Modifier Profil",
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
                    SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          EntryField(
                              title: 'Prenom',
                              controller: TextEditingController(),
                              prefixIcons: Icons.person,
                              height: 20),
                          SizedBox(height: 20),
                          EntryField(
                              title: 'Nom',
                              controller: TextEditingController(),
                              prefixIcons: Icons.person,
                              height: 20),
                          SizedBox(height: 20),
                          EntryField(
                              title: 'Number',
                              controller: TextEditingController(),
                              prefixIcons: Icons.phone,
                              height: 20),
                          SizedBox(height: 40),
                          EntryField(
                              title: 'Bio',
                              controller: TextEditingController(),
                              prefixIcons: Icons.question_answer,
                              height: 60),
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
