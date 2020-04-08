import 'dart:math';

import 'package:flutter/material.dart';

class Bubbles extends StatefulWidget {

  final List<Color> colors;
  final double x;
  final double y;
  final BubbleController bubbleController;

  const Bubbles({
    this.colors,
    this.x,
    this.y,
    this.bubbleController
  });

  @override
  State<StatefulWidget> createState() {
    return new _BubblesState();
  }
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  List<Bubble> bubbles = List();
  final int numberOfBubbles = 100;
  final double maxBubbleSize = 25.0;

  void _handleChange() {
    debugPrint('Bubble Controler x : ' + widget.bubbleController.x.toString() + " Y : " + widget.bubbleController.y.toString());
    if (widget.bubbleController.state == BubbleControllerState.playing) {
      startAnimation(widget.bubbleController.x, widget.bubbleController.y);
    } else if (widget.bubbleController.state == BubbleControllerState.stopped) {
      stopAnimation();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    widget.bubbleController.addListener(_handleChange);

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(seconds: 10), vsync: this);
    _controller.addListener(() {
      updateBubblePosition();
    });

//    startAnimation(0, 0);
  }

  void startAnimation(x, y) {
     debugPrint('START animation x : ' + x.toString() + " Y : " + y.toString());
    bubbles = List();
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(widget.colors[i % widget.colors.length], maxBubbleSize, x, y));
      i--;
    }
     setState(() {});
    _controller.forward(from: 0);
  }

  void stopAnimation() {
    // debugPrint('STOP animation');
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomPaint(
        foregroundPainter:
        BubblePainter(bubbles: bubbles, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }

  void updateBubblePosition() {
    bubbles.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;
  AnimationController controller;

  BubblePainter({this.bubbles, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    bubbles.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Bubble(Color colour, double maxBubbleSize, double x, double y) {
    this.colour = colour.withOpacity(Random().nextDouble());
    this.direction = Random().nextDouble() * 360;
    this.speed = 4;
    this.radius = Random().nextDouble() * maxBubbleSize;
    this.x = x;
    this.y = y;

    debugPrint("X is " + this.x.toString() + " y is " + this.y.toString());
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

//    assignRandomPositionIfUninitialized(canvasSize);
//
    randomlyChangeDirectionIfEdgeReached(canvasSize);
//    debugPrint("X is " + this.x.toString() + " y is " + this.y.toString());
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
       debugPrint('Assigning random position');
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}

class BubbleController extends ChangeNotifier {

  BubbleControllerState _state = BubbleControllerState.playing;

  double x = 0;
  double y = 0;

  BubbleControllerState get state => _state;

  void play(x, y) {
    debugPrint('Play bubble controler x : ' + x.toString() + " Y : " + y.toString());
    this.x = x;
    this.y = y;
    _state = BubbleControllerState.playing;

    notifyListeners();
  }

  void stop() {
    _state = BubbleControllerState.stopped;
    notifyListeners();
  }
}

enum BubbleControllerState {
  playing,
  stopped,
}
