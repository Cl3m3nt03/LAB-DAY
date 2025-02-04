import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class Searchbar extends StatefulWidget {
  final searchBuilder;
  const Searchbar({super.key, required this.searchBuilder});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {

  final FloatingSearchBarController controller = FloatingSearchBarController();

  String _searchQuery = ''; // Variable pour la requête utilisateur

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
          hint: 'Cherche un projet...',
          scrollPadding: const EdgeInsets.only(top: 13, bottom: 56),
          transitionDuration: const Duration(milliseconds: 800),
          transitionCurve: Curves.easeInOut,
          debounceDelay: const Duration(milliseconds: 500),
          physics: const BouncingScrollPhysics(),
          controller: controller,
          automaticallyImplyBackButton: false,
          backdropColor: Colors.transparent,
          closeOnBackdropTap: true,
          onQueryChanged: (query) {
            setState(() {
              _searchQuery = query.trim().toLowerCase();
            });
          },
          actions: [
            FloatingSearchBarAction(
              showIfOpened: false,
              child: CircularButton(
                icon: const Icon(Icons.search), 
                onPressed: (){})
              ),
            FloatingSearchBarAction(
              showIfOpened: true,
              showIfClosed: false,
              child: CircularButton(
                icon: const Icon(CupertinoIcons.clear), 
                onPressed: (){  
                  controller.close();
                })
              ),
          ],
          builder: (context, transition) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 0,
                child: widget.searchBuilder,
              ),
            );
          },
        );
    }
  }
