import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makeitcode/theme/custom_colors.dart';

/// Custom Navbar widget with tabs for navigation and styling.
class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  
  CustomColors? customColor;

   CustomNavbar({

    required this.selectedIndex,
    required this.onTabChange,
  });
  /// Builds the custom navbar with icons and labels, styled using Google Fonts.
  @override
  Widget build(BuildContext context) {
    customColor = Theme.of(context).extension<CustomColors>();
    return SingleChildScrollView(
      child : Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: customColor?.deepOcean.withOpacity(0.2)??const Color.fromARGB(255, 19, 19, 25).withOpacity(0.2), width: 1),
        ),
        color: customColor?.deepOcean??Color.fromRGBO(11, 22, 44, 1),
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: customColor?.navbutton?? Color.fromRGBO(0, 113, 152, 1),
            tabs: [
              GButton(
                icon: Icons.chat,
                text: 'Chat',
                textStyle: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.school,
                text: 'Projets',
                textStyle: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
                iconColor: Colors.white,
              ),
              GButton(
                  leading: Image.asset(
                  'assets/icons/logo.png',
                  width: 29, 
                  height: 29,
                ),
                icon: Icons.home,
                text: 'Accueil',
                textStyle: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.games,
                text: 'Jeux',
                textStyle: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
                iconColor: Colors.white,
              ),
              GButton(
                icon: Icons.person,
                text: 'Paramètres',
                textStyle: GoogleFonts.montserrat(textStyle: TextStyle( color: Colors.white, fontWeight: FontWeight.bold,fontSize: 13),),
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

