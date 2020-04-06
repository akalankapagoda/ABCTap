// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:developer';

import 'package:ads/ads.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:abctap/AppAds.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { // Probably fucked up here with stateless widget, but it works
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABC Tap',
      home: Letters(),
    );
  }
}

class LettersState extends State<Letters> {
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
  // TODO: Find out screen size and decide few levels of font sizes
  final _biggerFont = const TextStyle(
      fontSize: 500.0);
  final _mwFont = const TextStyle(fontSize: 450);
  int letterIndex = 0;
  int colorIndex = 0;
  int soundIndex = 0;
  Offset tapPosition = Offset.zero;

  Widget _buildBody() {
    return InkWell(
      child: _buildTile(),
      onLongPress: () {
        AppAds.showBanner();
        changeLetter(tapPosition);
      },
      onTapDown: (TapDownDetails details) {
        AppAds.showBanner();
        changeLetter(details.localPosition);
      },
      onDoubleTap: () {
        AppAds.hideBanner();
      },
    );
  }

  void changeLetter(Offset localPosition) {
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

    TextStyle activeTextStyle;

    if (_suggestions[letterIndex] == 'M' || _suggestions[letterIndex] == 'W') {
      activeTextStyle = _mwFont;
    } else {
      activeTextStyle = _biggerFont;
    }

    String imageURL = "assets/alphabet/" + _suggestions[letterIndex] + ".png";
    return GridTile(
        child: Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 10.0, color: Color(0xFFFF000000)),
          right: BorderSide(width: 10.0, color: Color(0xFFFF000000)),
          bottom: BorderSide(width: 10.0, color: Color(0xFFFF000000)),
        ),
        color: _colors[colorIndex],
        image: DecorationImage(
          image: AssetImage(imageURL),
          fit: BoxFit.contain,
        ),
      ),
      child: Stack(
        children: <Widget>[
//          Center(
//              child: Text(
//            _suggestions[letterIndex],
//            style: activeTextStyle,
//          )),
          Positioned(
            child: PimpedButton(
              particle: DemoParticle(),
              pimpedWidgetBuilder: (context, controller) {
                controller.forward(from: 0.0);
//                return FloatingActionButton(
//                  mini: true,
//                  elevation: 0,
//                  backgroundColor: Colors.transparent,
//                  onPressed: () {},
//                );
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
                return Container(
                  width: 100,
                  height: 100
                );
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
                return Container(
                    width: 150,
                    height: 150
                );
              },
            ),
            left: tapPosition.dx - 75,
            top: tapPosition.dy - 75,
          ),
        ],
      ),
    ));
  }

  Future<AudioPlayer> playSound(String sound) async {
    AudioCache cache = new AudioCache();
    return await cache.play(sound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}

class Letters extends StatefulWidget {
  @override
  LettersState createState() => LettersState();
}
