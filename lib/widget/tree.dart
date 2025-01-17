// Permet de verifier si l'utilisateur est connecté ou non et de rediriger vers la page de connexion 
//ou la page principale

import 'package:flutter/material.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/PageManagement.dart';
import 'package:makeitcode/page/login_register/login_page.dart';



class WidgetTree extends StatefulWidget{
  const WidgetTree ({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build (BuildContext context){
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return PageManagement();
      }else{
        return LoginPage();
      }
    },
    );
  }
}