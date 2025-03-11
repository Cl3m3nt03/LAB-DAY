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


@override
void initState() {
    super.initState();
}

void _startTimer(SMIInput<bool> toggleSpark){
  _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    _spark(toggleSpark);
  });
}

void _spark(SMIInput<bool> toggleSpark){
  if(countBeforeSpak >= 3){
    countBeforeSpak = 0;
    print('Valeur: $toggleSpark.value');
    toggleSpark.value = true;
  }
  else{
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
                print("Test2 ${levelValue?.value} ${_currentLvlRive?.value}");
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




SMIInput<double>? levelValue;
SMIInput<double>? _currentLvlRive;
int countBeforeSpak = 0;

void onInit(Artboard artboard) async {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    print(_controller);
    artboard.addController(_controller);

    SMIInput<bool>? toggleSpark = _controller.findInput<bool>('toggleSpark');

    //double level = event.properties['Level'] as double;
    SMIInput<double>? levelValue = _controller.findInput<double>('currentLvl');
    _currentLvlRive = _controller.findInput<double>('LevelThatIsChanged');
    levelValue?.value = 10;
    print("Test ${levelValue?.value} ${_currentLvlRive?.value}");

    _startTimer(toggleSpark!);

    _controller.addEventListener(onRiveEvent);

        WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
}

void onRiveEvent(RiveEvent event) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
        print("Test3 ${levelValue?.value} ${_currentLvlRive?.value}");
        _showLevelInfoModal(context);
    });
  });
}




@override
void dispose() {
    _controller.removeEventListener(onRiveEvent);
    _controller.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: SingleChildScrollView(
        controller: _scrollController,
    scrollDirection: Axis.vertical,
    child: SizedBox(
      height: 2500, // Mets une hauteur plus grande que l'écran pour activer le scroll
      child: RiveAnimation.asset(
        'assets/rive/levelmap.riv',
        onInit: onInit,
      ),
    ),
  ),
);
  }
}


/*Scaffold(
  body: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SizedBox(
      height: 1250, // Mets une hauteur plus grande que l'écran pour activer le scroll
      child: RiveAnimation.asset(
        'assets/rive/levelmap.riv',
        onInit: onInit,
      ),
    ),
  ),
);*/