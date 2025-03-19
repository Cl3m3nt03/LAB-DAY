import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/widget/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/theme/custom_colors.dart';
// This page allows users to reset their password by entering their email

class PasswordForgottenPage extends StatelessWidget {
  CustomColors? customColor;
  // Controller to handle input for the email field

  final TextEditingController emailController = TextEditingController();

// The main widget that builds the password reset page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        backgroundColor:  customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
      ),
      // GestureDetector to dismiss the keyboard when tapping outside input field
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        // LayoutBuilder to handle dynamic resizing based on screen size and keyboard visibility
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    decoration:  BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 113, 152, 1),
                          customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
                        ],
                        stops: [0.2, 0.9],
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Vous avez oublié votre mot de passe ?',
                            style: GoogleFonts.montserrat(textStyle : TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold)),
                          ),
                          const Divider(color: Colors.amber),
                          const SizedBox(height: 15),
                             Text(
                            'Saisissez l\'adresse email associée à votre compte MakeitCode ',
                            style:GoogleFonts.montserrat(textStyle : TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w500,),),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Un e-mail de réinitialisation vous sera envoyé.',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          EntryField(
                            title: 'Email',
                            controller: emailController,
                            prefixIcons: Icons.email,
                            height: 20,
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                shadowColor: customColor?.dark ?? Colors.black,
                                elevation: 5,
                                minimumSize: const Size(double.infinity, 55),
                                backgroundColor: const Color.fromARGB(249, 161, 119, 51),
                              ),
                              onPressed: () {
                                Auth().sendPasswordResetEmail(
                                  emailController.text,
                                  context,
                                );
                              },
                              child:Text(
                                'Valider',
                                style: GoogleFonts.montserrat(textStyle: TextStyle( fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: 20,color: Colors.white),)
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
