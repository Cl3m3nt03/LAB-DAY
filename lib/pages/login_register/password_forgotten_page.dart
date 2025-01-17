import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:makeitcode/widget/auth.dart';

class PasswordForgottenPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 11, 22, 44),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 113, 152, 1),
                          Color.fromARGB(255, 11, 22, 44),
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
                          const Text(
                            'Vous avez oublié votre mot de passe ?',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const Divider(color: Colors.amber),
                          const SizedBox(height: 15),
                          const Text(
                            'Saisissez l\'adresse email associée à votre compte MakeitCode ',
                            style: TextStyle(fontSize: 15, color: Colors.white),
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
                                shadowColor: Colors.black,
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
                              child: const Text(
                                'Valider',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
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
