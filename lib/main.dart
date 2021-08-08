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

class PlayWithMe extends StatelessWidget {
  const PlayWithMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Toy.circle(),
      ),
    );
  }
}
