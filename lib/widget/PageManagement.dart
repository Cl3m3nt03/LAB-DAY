//Permet de faire la gestion de la page principale avec la NavBar et les différentes pages

import 'package:flutter/material.dart';
import 'package:makeitcode/page/home_page.dart';
import 'package:makeitcode/page/login_page.dart';
import 'package:makeitcode/widget/navBar.dart';
import 'package:makeitcode/widget/tree.dart'; 

class PageManagement extends StatefulWidget {
const PageManagement({Key? key}) : super(key: key);

  @override
  _PageManagementState createState() => _PageManagementState();
}

class _PageManagementState extends State<PageManagement> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  final List<Widget> _pages = [
    Center(child: Text('Communauté', style: TextStyle(fontSize: 24))),
    Center(child: Text('Projets', style: TextStyle(fontSize: 24))),
    HomePage(),
    Center(child: Text('Classement', style: TextStyle(fontSize: 24))),
    Center(child: Text('Profil', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CustomNavbar(
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
              _currentIndex = index;
                _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut
            );
          });
        },
      ),
    );
  }
}
