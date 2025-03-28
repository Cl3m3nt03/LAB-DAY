import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makeitcode/theme/theme.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:makeitcode/pages/login_register/password_forgotten_page.dart';
import 'package:makeitcode/pages/login_register/register_page.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/widget/toastMessage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/theme/custom_colors.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();


} 

class _LoginPageState extends State <LoginPage>{
  CustomColors? customColor;
  bool isLogin = true;
  bool isPasswordVisible = true;
  bool suffixIcon = false;
  String? errormessage = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ToastMessage toast = ToastMessage();



  // Function to sign in user with email and password
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
  // Submit button widget for login
  Widget _submitButton(){
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 0),
    child:TextButton(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: customColor?.dark ?? Colors.black,
      elevation: 5,
      minimumSize: const Size(double.infinity, 55),
      backgroundColor: customColor?.goldenOak??Color.fromARGB(249, 161, 119, 51),

    ),
    onPressed:  signInWithEmailAndPassword, 
    child: Text( 'CONNEXION' ,style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),)
    ),
    ),
    );
  }
  // Widget for the "Forgot Password?" link
  Widget _passwordForgotten(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  PasswordForgottenPage()));
          },
          child: Text('Mot de passe oublié ?',style: GoogleFonts.montserrat(textStyle: TextStyle(color:customColor?.goldenOak?? Color.fromARGB(249, 161, 119, 51),fontWeight: FontWeight.bold),),),
        ),
      ],
    );
  }
  // Title widget displaying "Connectez-vous"
    Widget _title(){
    return Text(
      "Connectez-vous",style:GoogleFonts.montserrat(textStyle: TextStyle(
        color: customColor?.whiteAll??Colors.white.withOpacity(1), 
        fontSize: 30, 
        fontWeight: FontWeight.bold,     
      ),
      ),
    );
  }
    // Text widget for the "Or connect with" message
    Widget _moreConnexion(){
    return  Text('Ou connectez-vous avec',style:GoogleFonts.montserrat(textStyle: TextStyle(color: customColor?.white?? Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold),),);
  }
    // Widget asking if the user has an account and showing the sign-up link
      Widget _noAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?",style: GoogleFonts.montserrat(textStyle:TextStyle(color: customColor?.white?? Colors.white.withOpacity(0.5),fontWeight: FontWeight.bold,fontSize: 11.5),),),
        TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
          },
          child: Text('Inscrivez-vous',style: GoogleFonts.montserrat(textStyle:TextStyle(color: customColor?.goldenOak?? Color.fromARGB(248, 211, 157, 70),fontWeight: FontWeight.bold,fontSize: 12.5),),),
        ),
      ],
    );
  }

// Button for Google sign-in or sign-out

      Widget _moreConnexionButton(){
  return Padding(padding: const EdgeInsets.symmetric(horizontal: 0),
    child : Row(
  children: [
    Expanded(
      child: TextButton(
        onPressed: () {
          Auth().signInWithGoogle(context);
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadowColor: customColor?.dark ?? Colors.black,
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
              style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),)
            ),
          ],
        ),
      ),
    ),
  ],
),
);
}


// The main widget for the login page layout

  @override
  Widget build (BuildContext context){
    customColor = Theme.of(context).extension<CustomColors>();
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body:Container(
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [customColor?.skyBlue?? Color.fromRGBO(0, 113, 152, 1),customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44)], 
            stops: [0.2, 0.9],
            begin: Alignment.topCenter,
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
