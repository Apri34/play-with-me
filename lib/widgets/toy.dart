import 'package:flutter/material.dart';

class Toy extends StatelessWidget {
  final _Form form;

  Toy._({required this.form});

  factory Toy.triangle() => Toy._(form: _Form.TRIANGLE);

  factory Toy.circle() => Toy._(form: _Form.CIRCLE);

  factory Toy.rectangle() => Toy._(form: _Form.RECTANGLE);

  @override
  Widget build(BuildContext context) {
    final double size = 100;
    return CustomPaint(
      size: Size(size, size),
      painter: ToyPainter(form),
    );
  }
}

class ToyPainter extends CustomPainter {
  final _Form form;

  ToyPainter(this.form);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.black;
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
