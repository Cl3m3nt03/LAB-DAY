import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomNavbar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child : Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color.fromARGB(255, 19, 19, 25).withOpacity(0.2), width: 1),
        ),
        color: Color.fromRGBO(11, 22, 44, 1),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: const Color.fromRGBO(0, 113, 152, 1),
            tabs: [
              GButton(
                icon: Icons.chat,
                text: 'Communauté',
                textStyle: TextStyle(fontFamily: 'aBeeZee', color: Colors.white, fontWeight: FontWeight.bold),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.school,
                text: 'Projets',
                textStyle: TextStyle(fontFamily: 'aBeeZee', color: Colors.white, fontWeight: FontWeight.bold),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.home,
                text: 'Accueil',
                textStyle: TextStyle(fontFamily: 'aBeeZee', color: Colors.white, fontWeight: FontWeight.bold),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.emoji_events,
                text: 'Classement',
                textStyle: TextStyle(fontFamily: 'aBeeZee', color: Colors.white, fontWeight: FontWeight.bold),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.person,
                text: 'Profil',
                textStyle: TextStyle(fontFamily: 'aBeeZee', color: Colors.white, fontWeight: FontWeight.bold),
                iconColor: Colors.white,
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    ),
    );
  }
}

