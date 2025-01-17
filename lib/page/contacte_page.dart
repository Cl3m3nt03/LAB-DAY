import 'package:flutter/material.dart';
import 'package:makeitcode/widget/MenuItem.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:popover/popover.dart';

class ContactePage extends StatefulWidget {
  const ContactePage({super.key});

  @override
  _ContactePageState createState() => _ContactePageState();
}

class _ContactePageState extends State<ContactePage> {

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
                                    "Contactez-nous",
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
                              title: 'Email',
                              controller: TextEditingController(),
                              prefixIcons: Icons.mail,
                              height: 20),
                          SizedBox(height: 20),
                          
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
