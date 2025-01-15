import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/auth.dart';
class PasswordForgottenPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 11, 22, 44),
      ),
      body:   Container(
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
            child : Padding(padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Vous avez oublié votre mot de passe ?', style: TextStyle(fontSize: 20,color: Colors.white),),
            Divider(color: Colors.amber,),
            SizedBox(height: 15),
            Text('Saisissez l/adresse email associée à votre compte MakeitCode ',
              style: TextStyle(fontSize: 15,color: Colors.white),
              textAlign: TextAlign.left, 
            ),
            SizedBox(height: 20),
            Text('Un e-mail de reinitialisation vous sera envoyé.',style: TextStyle(fontSize: 15,color: Colors.white),),
            SizedBox(height: 20),
            EntryField(title: 'Email',controller:emailController,prefixIcons: Icons.lock,height: 20,),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                backgroundColor: Color.fromARGB(249, 161, 119, 51),
              ),
              onPressed: () {
                Auth().sendPasswordResetEmail( emailController.text, context);
              },
              child: Text('Valider', 
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
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