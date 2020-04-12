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

void main() => runApp(ABCTap());

class ABCTap extends StatefulWidget {

  @override
  LettersState createState() => LettersState();

  }

class LettersState extends State<ABCTap> {
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
  int letterIndex = 0;
  int colorIndex = 0;
  int soundIndex = 0;
  Offset tapPosition = Offset.zero;
  ConfettiController confettiController = new ConfettiController(duration: Duration(milliseconds: 500));
  bool bubblesVisible = false;
  int adsCounter = 0;


  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]); // Make it fullscreen
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
      }
    );
  }

  void showAd() {
    AppAds.showBanner();

    Future.delayed(const Duration(seconds: 15), () {
      AppAds.hideBanner();

    });
  }

  void changeLetter(Offset localPosition) {
    confettiController.play();
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
  }

  Widget _buildTile() {
    playSound(_sounds[soundIndex]);

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
              child :ConfettiWidget(
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
            )
            ),
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
      return Bubbles(
          colors: _colors
      );
    } else {
      return Container();
    }
  }

  void toggleBubbles() {
    bubblesVisible = !bubblesVisible;
    setState(() {});
  }

  Future<AudioPlayer> playSound(String sound) async {
    AudioCache cache = new AudioCache();
    return await cache.play(sound);
  }

  Icon getFloatingButtonIcon() {
    if (bubblesVisible) {
      return Icon(Icons.pause);
    } else {
      return Icon(Icons.play_arrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABC Tap',
      home: Scaffold(
        body: _buildBody(),
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: _colors[colorIndex],
//          mini: true,
          onPressed: toggleBubbles,
          child: getFloatingButtonIcon()
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
