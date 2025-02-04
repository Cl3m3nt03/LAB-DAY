import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 110,
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
                                    style: GoogleFonts.montserrat(textStyle:TextStyle(
                                      color: Color.fromARGB(250, 175, 142, 88),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          SizedBox(height: 40),
                          EntryField(
                              title: 'Bio',
                              controller: TextEditingController(),
                              prefixIcons: Icons.question_answer,
                              height: 60),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(250, 175, 142, 88),
                      ),
                      child: Text(
                        "Envoyer le message",
                        style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 13,color: Colors.white),),                      
                        ),
                    ),
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
