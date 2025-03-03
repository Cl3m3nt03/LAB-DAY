import 'package:flutter/material.dart';
import 'package:makeitcode/pages/games/questionnaire/questionnaire_list_page.dart';
import 'package:makeitcode/pages/community/global_chat_page.dart';
import 'package:makeitcode/pages/games/projects/glossary_page.dart';
import 'package:makeitcode/pages/home_page.dart';
import 'package:makeitcode/pages/profil/profile_page.dart';
import 'package:makeitcode/pages/games/projects/projects_page.dart';
import 'package:makeitcode/widget/navBar.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Manages the main page with a NavBar and different pages navigation.
class PageManagement extends StatefulWidget {
const PageManagement({Key? key}) : super(key: key);

  @override
  _PageManagementState createState() => _PageManagementState();
}

/// Manages the state of the PageManagement widget, including the current page and navigation.
class _PageManagementState extends State<PageManagement> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);

  final List<Widget> _pages = [
    GlobalChatPage(),
    ProjectsPage(),
    HomePage(),
    QuestionnaireListPage(),
    ProfilePage(),
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
