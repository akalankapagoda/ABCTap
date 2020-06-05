// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:abctap/AppAds.dart';
import 'package:abctap/bubbles.dart';
import 'package:confetti/confetti.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ABC Tap', debugShowCheckedModeBanner: false, home: ABCTap());
  }
}

class ABCTap extends StatefulWidget {
  @override
  LettersState createState() => LettersState();
}

class LettersState extends State<ABCTap> with WidgetsBindingObserver {
  final _ads = AppAds.init();
  final _suggestions = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  final _colors = [
    Colors.deepOrangeAccent,
    Colors.deepOrange,
    Colors.pink,
    Colors.cyanAccent,
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.green,
  ];
  final _sounds = [
    "audio/Magic-Spell-B.mp3",
    "audio/Video-Game-Positive-Sound-A1.mp3",
    "audio/Video-Game-Power-Level-Up-A1.mp3",
    "audio/Video-Game-Power-Level-Up-B1.mp3",
    "audio/Video-Game-Secret-Sound-A2.mp3",
    "audio/Video-Game-Secret-Sound-C1.mp3"
  ];

  final Map<String, bool> animalSound = {
    "C": true,
    "D": true,
    "E": true,
    "F": true,
    "L": true,
    "M": true,
    "P": true,
    "S": true
  };

  int letterIndex = 0;
  int colorIndex = 0;
  int soundIndex = 0;
  Offset tapPosition = Offset.zero;
  ConfettiController confettiController =
      new ConfettiController(duration: Duration(milliseconds: 500));
  bool bubblesVisible = false;
  bool autoPlay = false;
  int adsCounter = 0;
  bool addAdditionalPlayDelay = false;

  Offset center;

  AudioPlayer backgroundMusicPlayer;

  AudioCache letterChangeSoundPlayer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]); // Make it fullscreen
    WidgetsBinding.instance.addObserver(this);
    letterChangeSoundPlayer = new AudioCache(fixedPlayer: new AudioPlayer());
    loopSound("audio/music/cheeky_monkey_fun_app_playful_cheeky.mp3");
    playLetterSound();
  }

  Widget _buildBody() {
    if (++adsCounter == 50) {
      adsCounter = 0;
      showAd();
    }

    return InkWell(
        child: _buildTile(),
        onLongPress: () {
          changeLetter(tapPosition);
        },
        onTapDown: (TapDownDetails details) {
          changeLetter(details.localPosition);
        });
  }

  void showAd() {
    AppAds.showBanner();

    Future.delayed(const Duration(seconds: 15), () {
      AppAds.hideBanner();
    });
  }

  void changeLetter(Offset localPosition) {
    confettiController.play();

    if (autoPlay == true) {
      addAdditionalPlayDelay = true;
    }
    forward(localPosition);
  }

  void forward(Offset localPosition) {
    if (++letterIndex > 25) {
      letterIndex = 0;
    }

    if (++colorIndex > _colors.length - 1) {
      colorIndex = 0;
    }

    if (++soundIndex > _sounds.length - 1) {
      soundIndex = 0;
    }

    tapPosition = localPosition;

    setState(() => {}); // What the hell???

    playLetterSound();
  }

  Offset getCenter() {
    if (center == null) {
      center = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);
    }

    return center;
  }

  void reverse() {

    if (autoPlay == true) {
      addAdditionalPlayDelay = true;
    }

    tapPosition = getCenter();

    if (--letterIndex < 0) {
      letterIndex = 25;
    }

    if (++colorIndex > _colors.length - 1) {
      colorIndex = 0;
    }

    if (++soundIndex > _sounds.length - 1) {
      soundIndex = 0;
    }

    setState(() => {});

    playLetterSound();
  }

  Widget _buildTile() {

    String imageURL = "assets/alphabet/" + _suggestions[letterIndex] + ".png";
    return GridTile(
        child: Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 2.0, color: Color(0xFFFF000000)),
          right: BorderSide(width: 2.0, color: Color(0xFFFF000000)),
          bottom: BorderSide(width: 2.0, color: Color(0xFFFF000000)),
        ),
        color: _colors[colorIndex],
        image: DecorationImage(
          image: AssetImage(imageURL),
          fit: BoxFit.contain,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                controller.forward(from: 0.0);
              },
            ),
            left: tapPosition.dx,
            top: tapPosition.dy,
          ),
          Positioned(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                controller.forward(from: 0.0);
                return Container(
                  width: 70,
                  height: 70,
                );
              },
            ),
            left: tapPosition.dx - 35,
            top: tapPosition.dy - 35,
          ),
          Positioned(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                controller.forward(from: 0.0);
                return Container(width: 100, height: 100);
              },
            ),
            left: tapPosition.dx - 50,
            top: tapPosition.dy - 50,
          ),
          Positioned(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                controller.forward(from: 0.0);
                return Container(width: 150, height: 150);
              },
            ),
            left: tapPosition.dx - 75,
            top: tapPosition.dy - 75,
          ),
          Positioned(
            child: Container(
                child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 10,
              emissionFrequency: 0.5,
              gravity: 0.05,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
            )),
            left: tapPosition.dx,
            top: tapPosition.dy,
          ),
          getBubbles()
        ],
      ),
    ));
  }

  Widget getBubbles() {
    if (bubblesVisible) {
      return Bubbles(colors: _colors);
    } else {
      return Container();
    }
  }

  void toggleBubbles() {

    if (bubblesVisible) {
      playSound("audio/bubbles_pause.mp3");
    } else {
      playSound("audio/bubbles_play.mp3");
    }

    bubblesVisible = !bubblesVisible;

    setState(() {});
  }
  
  void toggleAutoPlay() {

    if (autoPlay) {
      playSound("audio/button_click_fast.mp3");
    } else {
      playSound("audio/button_click_fast.mp3");
    }

    autoPlay = !autoPlay;
    setState(() {});

    if (autoPlay) {
      Wakelock.enable();
      autoForward();
    } else {
      Wakelock.disable();
    }
  }

  void autoForward() {
    if (addAdditionalPlayDelay == true) {
      addAdditionalPlayDelay = false;
      // Avoid forwarding so we go two rounds
    } else {
      forward(getCenter());
    }


    int delay = 3500;


    Future.delayed(Duration(milliseconds: delay), () {
      if (autoPlay) {
        autoForward();
      }
    });
  }

  void playLetterSound() async {
    playSound(_sounds[soundIndex]);
    await letterChangeSoundPlayer.play("audio/voice/" + _suggestions[letterIndex] + ".mp3");
  }

  Future<AudioPlayer> playSound(String sound) async {
    AudioCache cache = new AudioCache();
    return await cache.play(sound);
  }

  void loopSound(String sound) async {
    AudioCache cache = new AudioCache();
    backgroundMusicPlayer = await cache.loop(sound, volume: 0.8);
  }

  Icon getPlayButtonIcon() {
    if (autoPlay) {
      return Icon(Icons.pause);
    } else {
      return Icon(Icons.play_arrow);
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.detached :
        pauseEverything();
        break;
      case AppLifecycleState.inactive :
        break;
      case AppLifecycleState.paused :
        pauseEverything();
        break;
      case AppLifecycleState.resumed :
        resumeEverything();
        break;
    }
  }

//
//  @override
//  Future<bool> didPopRoute() {
//    pauseEverything();
//  }

  void pauseEverything() {
    backgroundMusicPlayer?.pause();

    if(autoPlay) {
      autoPlay = false;
    }

    setState(() {});
  }

  void resumeEverything() {
    backgroundMusicPlayer?.resume();

    setState(() {});
  }

  void popApp() {
    pauseEverything();
    Navigator.of(context).pop(true);
  }

  Future<bool> onBackButtonPressed() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop(false);
        });

        return new AlertDialog(
          title: new Text('Are you sure?', style: TextStyle(fontSize: 28, color: Colors.white),),
          content: new Text('Do you want to exit ABC Tap?', style: TextStyle(fontSize: 20, color: Colors.white),),
          backgroundColor: _colors[colorIndex],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(false),
              color: Colors.transparent,
              child: Text('No', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            RaisedButton(
              onPressed: popApp,
              color: Colors.transparent,
              child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.white)),
            )
          ],
        );
      }
    );
  }

  Widget getAnimalSoundButton() {
    bool soundPresent = animalSound[_suggestions[letterIndex]];

    if (soundPresent != null && soundPresent) {
      return Row(
        children: <Widget>[
          Spacer(
            flex: 15,
          ),
          FloatingActionButton(
            backgroundColor: _colors[colorIndex],
            onPressed: playAnimalSound,
            child: Icon(Icons.volume_up)),
          Spacer(
            flex: 1,
          ),
        ],
      );
    } else {
      return Row();
    }
  }

  void playAnimalSound() async {
    await letterChangeSoundPlayer.play("audio/animals/" + _suggestions[letterIndex] + ".mp3");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackButtonPressed,
        child: Scaffold(
          body: _buildBody(),
          resizeToAvoidBottomPadding: false,
          floatingActionButton: Container(
            child: Column (
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(
                      flex: 2,
                    ),
                    FloatingActionButton(
                        backgroundColor: _colors[colorIndex],
                        onPressed: reverse,
                        child: Icon(Icons.arrow_back_ios)),
                    Spacer(
                      flex: 1,
                    ),
                    FloatingActionButton(
                        backgroundColor: _colors[colorIndex],
                        onPressed: toggleAutoPlay,
                        child: getPlayButtonIcon()),
                    Spacer(
                      flex: 1,
                    ),
                    FloatingActionButton(
                        backgroundColor: _colors[colorIndex],
                        onPressed: toggleBubbles,
                        child: Icon(Icons.grain)),
                    Spacer(
                      flex: 2,
                    ),
                    //add right Widget here with padding right
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    )
                  ],
                ),
                getAnimalSoundButton()
              ],
            )


          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }

  @override
  void dispose() {
    backgroundMusicPlayer?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
