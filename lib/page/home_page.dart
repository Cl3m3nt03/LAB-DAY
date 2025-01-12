import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeitcode/auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Auth().currentUser?.email ?? 'No email available'),
          Center(
        child: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Auth().signOut();
          },
        ),
        ),
        
        
        ],
      ),
    );
  }
}