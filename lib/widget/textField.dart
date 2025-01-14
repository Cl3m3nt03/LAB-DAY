import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EntryField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcons;

  EntryField({required this.title, required this.controller, required this.prefixIcons});

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.title == 'Mot de passe' ? isPasswordVisible : false || widget.title == 'Confirmer le mot de passe' ? isPasswordVisible : false,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.title == 'Mot de passe' || widget.title == 'Confirmer le mot de passe'
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: isPasswordVisible
                    ? Icon(CupertinoIcons.eye, color: Colors.white.withOpacity(0.5))
                    : Icon(CupertinoIcons.eye_slash, color: Colors.white.withOpacity(0.5)),
                color: Colors.white.withOpacity(0.5),
              )
            : null,
        prefixIcon: Icon(widget.prefixIcons, color: Colors.white.withOpacity(0.5)),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        label: Text(
          widget.title,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold),
        ),
        filled: true,
        fillColor: Color.fromRGBO(24, 37, 63, 0.6),
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
}