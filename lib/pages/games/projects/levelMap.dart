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

double levelValue = 0;
double currentLvlRiveTest = 0;
int countBeforeSpak = 0;

void onInit(Artboard artboard) async {
    _controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1')!;
    print(_controller);
    artboard.addController(_controller);

    SMIInput<bool>? toggleSpark = _controller.findInput<bool>('toggleSpark');

    _startTimer(toggleSpark!);

    _controller.addEventListener(onRiveEvent);
}

void onRiveEvent(RiveEvent event) {
    // Access custom properties defined on the event
    double level = event.properties['Level'] as double;
    SMIInput<double>? currentLvlRive = _controller.findInput<double>('currentLvl');

    if(currentLvlRive != null){
      currentLvlRive.value = level;
    }
    // Schedule the setState for the next frame, as an event can be
    // triggered during a current frame update
    WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
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
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/rive/levelmap.riv',
              onInit: onInit,
            )
          ),
        ],
      ),
    );
  }
}