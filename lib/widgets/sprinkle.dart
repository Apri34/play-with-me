import 'dart:math';

import 'package:flutter/material.dart';

class Sprinkle extends StatefulWidget {
  Sprinkle({required Key key, required this.onCompleteListener})
      : super(key: key);

  final void Function(Key key) onCompleteListener;

  @override
  _SprinkleState createState() => _SprinkleState();
}

class _SprinkleState extends State<Sprinkle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 3),
  )
    ..forward()
    ..addListener(() {
      setState(() {});
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed)
        widget.onCompleteListener(widget.key!);
    });
  late final Animation<double> _animation =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.linear),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _createSprinkles(context),
    );
  }

  List<Widget> _createSprinkles(BuildContext context) {
    return List.generate(
        10, (index) => _createSprinkle(context, pi / 5 * index));
  }

  Widget _createSprinkle(BuildContext context, double radians) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double sprinkleRadius = 15;
    double radius = sqrt(pow(width, 2) + pow(height, 2)) * 1.2;

    return Positioned(
      left: width / 2 -
          sprinkleRadius +
          sin(pi / 2 - radians) * _animation.value * radius,
      top: height / 2 -
          sprinkleRadius +
          sin(radians) * _animation.value * radius,
      width: sprinkleRadius * 2,
      height: sprinkleRadius * 2,
      child: CustomPaint(
        size: Size(sprinkleRadius * 2, sprinkleRadius * 2),
        painter: SprinklePainter(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SprinklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
