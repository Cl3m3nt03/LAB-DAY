import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();


} 

class _LoginPageState extends State <LoginPage>{
  bool isLogin = true;
  bool isPasswordVisible = true;
  bool suffixIcon = false;
  String? errormessage = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWhithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
    }
  }         
  
      

  Widget _entryField(String title, TextEditingController controller,prefixIcons ){
    
    return TextField(
      controller:controller,
      obscureText: title == 'Mot de passe' ? isPasswordVisible : false,
      
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: title == 'Mot de passe' ? IconButton(
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
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
    child:TextButton(
    style: TextButton.styleFrom(
      minimumSize: const Size(double.infinity, 55),
      backgroundColor: const Color.fromRGBO(95,194, 186, 1),
    ),
    onPressed:  signInWithEmailAndPassword,
    child: Text( 'CONNEXION' ,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ,fontSize: 20,fontFamily: 'Monsterrat'),
    ),
    ),
    );
  }



  Widget _passwordForgotten(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (){},
          child: Text('Mot de passe oublié ?',style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
    Widget _title(){
    return Text(
      "Connectez-vous",style: TextStyle(
        color: Colors.white.withOpacity(1), 
        fontSize: 31, 
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',      
      ),
    );
  }

    Widget _moreConnexion(){
    return  Text('Ou connectez-vous avec',style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),);
  }

      Widget _noAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?",style: TextStyle(color: Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold,fontSize: 13),),
        TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: Text('Inscrivez-vous',style: TextStyle(color: const Color.fromRGBO(95,194, 186, 1),fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }

      Widget _moreConnexionButton(){
  return Row(
  children: [
    Expanded(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(21, 49, 104, 1),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const Icon(Icons.facebook, color: Colors.white,size: 25,), 
            const SizedBox(width: 10),
            const Text(
              'FACEBOOK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
      const SizedBox(width: 10), 
    Expanded(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: const Color.fromRGBO(166, 32, 54, 1),
          padding: const EdgeInsets.symmetric(vertical: 15), 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            const Image(
              image: AssetImage('assets/icons/google.png'),
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10),
            const Text(
              'GOOGLE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);
}



  @override
  Widget build (BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body:Container(
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Color.fromRGBO(0, 113, 152, 1),Color.fromARGB(255, 11, 22, 44)], 
            stops: [0.1, 0.9], 
            center: Alignment(-0.7, 0.7),
             radius: 0.8,
        ),
        ),
      child: SingleChildScrollView(
      child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
        child: Column(
          children: [
           SizedBox(height: MediaQuery.of(context).size.height / 13),
            Align(
              alignment: Alignment.center,
            child:_title(),
            ),
            const SizedBox(height: 30),
            _entryField('Adresse email', emailController, Icons.mail),
            const SizedBox(height: 20),
            _entryField('Mot de passe', passwordController, Icons.lock),
            _passwordForgotten(),
            const SizedBox(height: 10),
            _submitButton(),
            const SizedBox(height: 20),
            _moreConnexion(),
            const SizedBox(height: 20),
            _moreConnexionButton(),
            const SizedBox(height: 10),
            _noAccount(),
          ],
        )
        ),
      ),
      ),
      ),
    );
  }
}
