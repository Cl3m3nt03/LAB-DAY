import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Levelmap extends StatefulWidget {
  const Levelmap({super.key});

  @override
  State<Levelmap> createState() => _LevelmapState();
}

class _LevelmapState extends State<Levelmap> {
  late StateMachineController _controller;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  SMIInput<double>? levelValue;
  SMIInput<double>? _currentLvlRive;
  int countBeforeSpak = 0;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer(SMIInput<bool> toggleSpark) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _spark(toggleSpark);
    });
  }

  void _spark(SMIInput<bool> toggleSpark) {
    if (countBeforeSpak >= 3) {
      countBeforeSpak = 0;
      toggleSpark.value = true;
    } else {
      toggleSpark.value = false;
      countBeforeSpak++;
    }
  }

  void _showLevelInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Niveau atteint !", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Voici quelques informations sur votre progression."),
              ElevatedButton(
                onPressed: () {
                  _currentLvlRive?.value = 0;
                  Navigator.pop(context);
                },
                child: Text("Fermer"),
              ),
            ],
          ),
        );
      },
    );
  }

  void onInit(Artboard artboard) {
    _controller = StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    artboard.addController(_controller);

    SMIInput<bool>? toggleSpark = _controller.findInput<bool>('toggleSpark');
    levelValue = _controller.findInput<double>('currentLvl');
    _currentLvlRive = _controller.findInput<double>('LevelThatIsChanged');
    levelValue?.value = 10;
    _currentLvlRive?.value = 0;

    _startTimer(toggleSpark!);

    // Ne pas ajouter d'event listener ici
    // _controller.addEventListener(onRiveEvent);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  // Déclencher l'événement seulement quand on clique sur un bouton
  void _triggerRiveEvent() {
    setState(() {
      _showLevelInfoModal(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        // Carte interactive avec Rive
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: 2500, // Hauteur suffisante pour scroller
            child: GestureDetector(
              onTap: _triggerRiveEvent, // Déclenchement du clic
              child: RiveAnimation.asset(
                'assets/rive/levelmap.riv',
                onInit: onInit,
              ),
            ),
          ),
        ),

        // Bouton de retour en haut à gauche
        Positioned(
          top: 40, // Ajuste la position verticale
          left: 16, // Ajuste la position horizontale
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context); // Retour en arrière
            },
            backgroundColor: Colors.white.withOpacity(0.8), // Fond semi-transparent
            elevation: 3,
            mini: true, // Petit bouton
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

}
