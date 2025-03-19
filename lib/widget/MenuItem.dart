import 'package:flutter/material.dart';
import 'package:makeitcode/theme/custom_colors.dart';
import 'package:popover/popover.dart';
import 'package:google_fonts/google_fonts.dart';

/// A custom popover menu widget triggered by a tap event.
class popoverMenu extends StatelessWidget {
    CustomColors? customColor;

   popoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    return GestureDetector(
      onTap:() => showPopover(context: context, bodyBuilder: (context) => Listitem(),
      width: MediaQuery.of(context).size.width - 40,
      height: 200,
      ),
      child: Icon(Icons.menu, size: 40,color: customColor?. vibrantBlue ?? Color.fromARGB(250, 175, 142, 88),),
    );
  }
}

/// A list of language options in the popover, each with a switch to toggle the language.
class Listitem extends StatelessWidget {
   Listitem({super.key});
  CustomColors? customColor;

  @override
  Widget build(BuildContext context) {
    
    customColor = Theme.of(context).extension<CustomColors>();

    return  Column(
      children: [
        //1st menu options
        Container(
          height: 200,
          color: customColor?. vibrantBlue ?? Color.fromARGB(250, 175, 142, 88),
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
                              Text("Anglais", style:  GoogleFonts.montserrat(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),),),
                            SizedBox(width: MediaQuery.of(context).size.width - 230),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: customColor?. vibrantBlue ??Color.fromARGB(250, 175, 142, 88),
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
                              Text("Français", style:GoogleFonts.montserrat(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),),),
                            SizedBox(width: MediaQuery.of(context).size.width - 240),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: customColor?. vibrantBlue ?? Color.fromARGB(250, 175, 142, 88),
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
                              Text("Chinois", style:GoogleFonts.montserrat(textStyle:TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18),),),
                            SizedBox(width: MediaQuery.of(context).size.width - 230),
                              Switch(
                                value: true,
                                onChanged: (value) {},
                                activeTrackColor: Color.fromARGB(66, 255, 255, 255),
                                activeColor: customColor?.vibrantBlue ??Color.fromARGB(250, 175, 142, 88),
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