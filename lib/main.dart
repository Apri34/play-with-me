import 'package:flutter/material.dart';
import 'package:play_with_me/widgets/toy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlayWithMe(),
    );
  }
}

class PlayWithMe extends StatefulWidget {
  const PlayWithMe({Key? key}) : super(key: key);

  @override
  _PlayWithMeState createState() => _PlayWithMeState();
}

class _PlayWithMeState extends State<PlayWithMe> {
  final double minSize = 50;
  final double maxSize = 150;

  late double size;
  Offset? position;

  @override
  void initState() {
    size = 100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: position?.dx ??
                MediaQuery.of(context).size.width / 2 - size / 2,
            top: position?.dy ??
                MediaQuery.of(context).size.height / 2 - size / 2,
            child: Draggable(
              feedback: Container(),
              child: Toy(size: size),
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  position = offset;
                });
              },
              onDragUpdate: (dragUpdateDetails) {
                setState(() {
                  position = Offset(
                    dragUpdateDetails.globalPosition.dx - size / 2,
                    dragUpdateDetails.globalPosition.dy - size / 2,
                  );
                });
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Slider(
              value: size,
              min: minSize,
              max: maxSize,
              onChanged: (value) {
                setState(() {
                  size = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
