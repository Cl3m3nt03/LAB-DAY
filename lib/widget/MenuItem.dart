import 'package:flutter/material.dart';
import 'package:popover/popover.dart';


class popoverMenu extends StatelessWidget {
  const popoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => showPopover(context: context, bodyBuilder: (context) => Listitem(),
      width: MediaQuery.of(context).size.width - 40,
      height: 200,
      ),
      child: Icon(Icons.menu, size: 40,color: Color.fromARGB(250, 175, 142, 88),),
    );
  }
}


class Listitem extends StatelessWidget {
  const Listitem({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        //1st menu options
        Container(
          height: 200,
          color: Color.fromARGB(250, 175, 142, 88),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text('🇬🇧'),
                              SizedBox(width: 20,),
                              Text("Anglais", style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(width: MediaQuery.of(context).size.width - 230),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: Color.fromARGB(250, 175, 142, 88),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text('🇫🇷'),
                              SizedBox(width: 20,),
                              Text("Français", style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(width: MediaQuery.of(context).size.width - 240),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: Color.fromARGB(250, 175, 142, 88),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Text('🇨🇳'),
                              SizedBox(width: 20,),
                              Text("Chinois", style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(width: MediaQuery.of(context).size.width - 230),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: Color.fromARGB(250, 175, 142, 88),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}