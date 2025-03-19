import 'package:flutter/material.dart';
import 'package:makeitcode/widget/textField.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:makeitcode/theme/custom_colors.dart';


/// Page widget for displaying a contact form.
class ContactePage extends StatefulWidget {
  const ContactePage({super.key});

  @override
  _ContactePageState createState() => _ContactePageState();
}

/// State class for the ContactePage widget.
class _ContactePageState extends State<ContactePage> {
  CustomColors? customColor;
  // Declare controllers for the text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  /// Builds the UI for the contact page, including a gradient background,
  /// a header with a back button, and input fields for email and bio.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacter-nous',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                fontSize: 22,
                color: Colors.white),
          ),
        ),
        backgroundColor: customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color.fromRGBO(0, 113, 152, 1),
                customColor?.midnightBlue ?? Color.fromARGB(255, 11, 22, 44),
              ],
              stops: [0.1, 0.9],
              center: Alignment(-0.7, 0.7),
              radius: 0.8,
            ),
          ),
          child: Column(
            children: [
              Divider(
                thickness: 1.5,
                color: Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    EntryField(
                      title: 'Email',
                      controller: emailController,
                      prefixIcons: Icons.mail,
                      height: 20,
                    ),
                    SizedBox(height: 40),
                    EntryField(
                      title: 'Contenue',
                      controller: bioController,
                      prefixIcons: Icons.question_answer,
                      height: 60,
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ElevatedButton(
                onPressed: () async {
                  String username = 'makeitcode17@gmail.com';
                  String password = 'ywhvyqzzawtihqki';

                  final smtpServer = gmail(username, password);

                  final message = Message()
                    ..from = Address(emailController.text)
                    ..recipients.add('makeitcode17@gmail.com')
                    ..subject = 'Contact Form Submission'
                    ..text = bioController.text;

                  try {
                    final sendReport = await send(message, smtpServer);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email envoyé avec succès: ')),
                    );
                  } on MailerException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de l\'envoi de l\'email: ')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(249, 153, 120, 67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Envoyer le message",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13,
                      color: Colors.white,
                    ),
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