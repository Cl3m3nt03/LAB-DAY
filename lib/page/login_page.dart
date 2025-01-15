import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/auth.dart';
import 'package:makeitcode/page/password_forgotten_page.dart';
import 'package:makeitcode/page/register_page.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/widget/toastMessage.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
  final ToastMessage toast = ToastMessage();




  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWhithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      toast.showToast(context,'Connexion réussie', isError: false);

    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
        toast.showToast(context,'Email ou mot de passe incorrect. Veuillez réessayer !', isError: true);
      });
    }
  }         

  Widget _submitButton(){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
    child:TextButton(
    style: TextButton.styleFrom(
      shadowColor: Colors.black,
      elevation: 5,
      minimumSize: const Size(double.infinity, 55),
      backgroundColor: Color.fromARGB(249, 161, 119, 51),
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
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  PasswordForgottenPage()));
          },
          child: Text('Mot de passe oublié ?',style: TextStyle(color: Color.fromARGB(249, 161, 119, 51),fontWeight: FontWeight.bold),),
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
          child: Text('Inscrivez-vous',style: TextStyle(color: Color.fromARGB(248, 211, 157, 70),fontWeight: FontWeight.bold),),
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
          shadowColor: Colors.black,
          elevation: 5,
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
        onPressed: () {
          Auth().signInWithGoogle(context);
        },
        style: TextButton.styleFrom(
          shadowColor: Colors.black,
          elevation: 5,
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
            Text(Auth().currentUser == null ? 'GOOGLE' : 'Déconnexion',
              style: const TextStyle(
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
          gradient: LinearGradient(
            colors: [Color.fromRGBO(0, 113, 152, 1),Color.fromARGB(255, 11, 22, 44)], 
            stops: [0.2, 0.9],
            begin: Alignment.bottomCenter,
            end: Alignment.center, 
            
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
            EntryField(title: 'Email',controller: emailController,prefixIcons: Icons.email,height: 20,),
            const SizedBox(height: 20),
            EntryField(title: 'Mot de passe',controller: passwordController,prefixIcons: Icons.lock,height: 20,),
            _passwordForgotten(),
            const SizedBox(height: 5),
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
