import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();


} 

class _RegisterPageState extends State <RegisterPage>{
  bool isLogin = true;
  bool isPasswordVisible = true;
  bool suffixIcon = false;
  String? errormessage = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
    final TextEditingController pseudoController = TextEditingController();



  Future <void> createUserWithEmailAndPassword()async{
    try{
      await Auth().registerWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e){
      setState(() {
        errormessage = e.message;
      });
    }
  }
  
Widget _entryField(String title, TextEditingController controller,prefixIcons ){
    
    return TextField(
      controller:controller,
      obscureText: (title == 'Mot de passe' || title == 'Confirmation du mot de passe') ? isPasswordVisible : false,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: title == 'Mot de passe' || title == 'Confirmation du mot de passe'? IconButton(
          onPressed: (){
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: isPasswordVisible ? Icon(CupertinoIcons.eye, color: Colors.white.withOpacity(0.5)) : Icon(CupertinoIcons.eye_slash, color: Colors.white.withOpacity(0.5)),
          color: Colors.white.withOpacity(0.5),
        ) : null,
        prefixIcon: Icon(prefixIcons, color: Colors.white.withOpacity(0.5),),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        label: Text(title, style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),),
        filled: true,
        fillColor: Color.fromRGBO(50, 50, 79, 1),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
  Widget _submitButton(){
    return TextButton(
    style: TextButton.styleFrom(
      minimumSize: const Size(double.infinity, 55),
      backgroundColor: const Color.fromRGBO(95,194, 186, 1),
    ),
    onPressed:  createUserWithEmailAndPassword,
    child: Text( 'INSCRIPTION' ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ,fontSize: 20,fontFamily: 'Monsterrat'),
    ),
    );
  }

  Widget _errorMessage(){
    return Text(errormessage == ''? '' :'Erreur ? ',style: TextStyle(color: Colors.white),); 
  }


    Widget _title(){
    return Text(
      "Créer votre compte",style: TextStyle(
        color: Colors.white, 
        fontSize: 36, 
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',      
      ),
    );
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: Colors.white.withOpacity(1)),
      ),
      backgroundColor: Color.fromARGB(255, 11, 22, 44),
      body:SingleChildScrollView(
      child:Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
            child:_title(),
            ),
            const SizedBox(height: 20),
            _entryField('Pseudo', pseudoController, Icons.person),
            const SizedBox(height: 20),
            _entryField('Adresse email', emailController, Icons.mail),
            const SizedBox(height: 20),
            _entryField('Mot de passe', passwordController, Icons.lock),
            const SizedBox(height: 20),
             _entryField('Confirmation du mot de passe', confirmPasswordController, Icons.lock),
            const SizedBox(height: 20),
            _submitButton(),
          ],
        )
      ),
      ),
      ),
    );
    
  }
}
