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
          Center(
            child: Toy(size: size,),
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
