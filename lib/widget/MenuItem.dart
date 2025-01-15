import 'package:flutter/material.dart';
import 'package:popover/popover.dart';


class popoverMenu extends StatelessWidget {
  const popoverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() => showPopover(context: context, bodyBuilder: (context) => Listitem(),
      width: MediaQuery.of(context).size.width - 40,
      height: 150,
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
          height: 150,
          color: Color.fromARGB(250, 175, 142, 88),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('🇬🇧'),
                              Text("Anglais", style: TextStyle(color: Colors.white, fontSize: 20),),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        
      ],
    );
  }
}