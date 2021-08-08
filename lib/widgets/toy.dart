import 'dart:math';

import 'package:flutter/material.dart';

class Toy extends StatefulWidget {
  final _Form form;

  Toy._({required this.form});

  factory Toy.triangle() => Toy._(
        form: _Form.TRIANGLE,
      );

  factory Toy.circle() => Toy._(
        form: _Form.CIRCLE,
      );

  factory Toy.rectangle() => Toy._(
        form: _Form.RECTANGLE,
      );

  @override
  _ToyState createState() => _ToyState();
}

class _ToyState extends State<Toy> {
  static const List<Color> colors = [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.blue,
    Colors.red,
    Colors.cyan,
    Colors.deepPurple
  ];

  late Color color;

  @override
  void initState() {
    color = colors[Random().nextInt(colors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double size = 100;
    return GestureDetector(
      onTap: () {
        setState(() {
          int index = colors.indexOf(color);
          color = colors[index == colors.length - 1 ? 0 : index + 1];
        });
      },
      child: CustomPaint(
        size: Size(size, size),
        painter: ToyPainter(widget.form, color),
      ),
    );
  }
}

class ToyPainter extends CustomPainter {
  final _Form form;
  final Color color;

  ToyPainter(this.form, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    switch (form) {
      case _Form.CIRCLE:
        drawCircle(canvas, paint, size);
        break;
      case _Form.TRIANGLE:
        drawTriangle(canvas, paint, size);
        break;
      case _Form.RECTANGLE:
        drawRectangle(canvas, paint, size);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawCircle(Canvas canvas, Paint paint, Size size) {
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  void drawRectangle(Canvas canvas, Paint paint, Size size) {
    canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
        paint);
  }

  void drawTriangle(Canvas canvas, Paint paint, Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
}

enum _Form { TRIANGLE, RECTANGLE, CIRCLE }