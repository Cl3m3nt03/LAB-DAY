// Permet de lancer l'application et de definir que la page de départ est la page 
//de connexion(Widget Tree) sans la NavBar

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:makeitcode/page/login_page.dart';
import 'package:makeitcode/widget/PageManagement.dart';
import 'package:makeitcode/widget/tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WidgetTree(),
      },
    );
  }
}
