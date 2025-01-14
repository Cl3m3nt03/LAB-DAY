import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:makeitcode/page/profile_page.dart';
import 'package:makeitcode/widget/tree.dart';


Future<void> main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget{
  const Myapp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ProfilePage(),
    );
  }
}