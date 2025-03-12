// Permet de verifier si l'utilisateur est connecté ou non et de rediriger vers la page de connexion 
//ou la page principale

import 'package:flutter/material.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/widget/PageManagement.dart';
import 'package:makeitcode/pages/login_register/login_page.dart';


/// Widget that checks if the user is authenticated.
/// Redirects to the main page if authenticated, otherwise to the login page.

class WidgetTree extends StatefulWidget{
  const WidgetTree ({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

/// Manages the authentication state and navigates accordingly.
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