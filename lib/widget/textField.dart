import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:makeitcode/theme/custom_colors.dart';

/// Custom text field widget with optional password visibility toggle.
class EntryField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final IconData prefixIcons;
  final double height;

  EntryField({required this.title, required this.controller, required this.prefixIcons, required this.height});

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

/// State class for `EntryField`, managing password visibility.
class _EntryFieldState extends State<EntryField> {
  bool isPasswordVisible = true;
  CustomColors? customColor;


  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    return TextField(
      controller: widget.controller,
      obscureText: widget.title == 'Mot de passe'  ? isPasswordVisible : false || widget.title == 'Confirmer le mot de passe' ? isPasswordVisible : false || widget.title == 'Confirmer le Mot de Passe' ? isPasswordVisible : false || widget.title == 'Nouveau Mot de Passe' ? isPasswordVisible : false || widget.title == 'Ancien Mot de Passe' ? isPasswordVisible : false,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        suffixIcon: widget.title == 'Mot de passe' || widget.title == 'Confirmer le mot de passe' || widget.title == 'Confirmer le Mot de Passe' || widget.title == 'Nouveau Mot de Passe' || widget.title == 'Ancien Mot de Passe'
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
        contentPadding: EdgeInsets.symmetric(vertical: widget.height, horizontal: 30.0),
        label: Text(
          widget.title,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold),
        ),
        filled: true,
        fillColor: customColor?. Texfield ??Color.fromRGBO(24, 37, 63, 0.6),
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