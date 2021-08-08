import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:play_with_me/widgets/sprinkle.dart';
import 'package:play_with_me/widgets/toy.dart';
import 'package:shake/shake.dart';

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

class _PlayWithMeState extends State<PlayWithMe> with TickerProviderStateMixin {
  final double minSize = 50;
  final double maxSize = 150;

  late final AnimationController _flipController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 750),
  );

  late final _gravityController = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<double> flipAnimation =
      Tween<double>(begin: 0, end: 4 * pi).animate(
    CurvedAnimation(parent: _flipController, curve: Curves.linear),
  )..addListener(() {
          setState(() {});
        });

  late double size;
  double radians = 0.0;
  Offset? gravityBegin;
  Offset? gravityEnd;
  Offset? position;
  bool gravity = false;
  List<Sprinkle> sprinkles = [];
  double initialSize = 100;
  double initialRadians = 0.0;
  Offset? initialPosition;

  @override
  void initState() {
    size = 100;
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        sprinkles.add(
          Sprinkle(
              key: UniqueKey(),
              onCompleteListener: (key) {
                sprinkles.removeWhere((element) => element.key == key);
              }),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      position = Offset(MediaQuery.of(context).size.width / 2 - size / 2,
          MediaQuery.of(context).size.height / 2 - size / 2);
    }
    return GestureDetector(
      onScaleStart: (s) {
        initialSize = size;
        initialRadians = radians;
        initialPosition = position;
      },
      onScaleUpdate: (s) {
        radians = initialRadians + s.rotation;
        double scale = s.scale;
        if (scale > 1 && scale * initialSize <= maxSize) {
          size = initialSize * scale;
        } else if (scale < 1 && scale * initialSize >= minSize) {
          size = initialSize * scale;
        }
        position = Offset(
          initialPosition!.dx + initialSize / 2 - size / 2,
          initialPosition!.dy + initialSize / 2 - size / 2,
        );
        setState(() {});
      },
      child: Scaffold(
        body: Stack(
          children: [
            ...sprinkles,
            Positioned(
              left: position!.dx,
              top: position!.dy,
              child: Draggable(
                feedback: Container(),
                child: Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.005)
                    ..rotateY(flipAnimation.value),
                  child: Toy(
                    size: size,
                    radians: radians,
                  ),
                ),
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
                onDragEnd: (dragEndDetails) {
                  if (gravity) _runGravityAnimation(context);
                },
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Gravity"),
                      SizedBox(
                        width: 6,
                      ),
                      Switch(
                        value: gravity,
                        onChanged: (value) {
                          gravity = !gravity;
                          if (gravity) {
                            _runGravityAnimation(context);
                          }
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _flipController
                          .forward()
                          .then((_) => _flipController.reset());
                    },
                    child: Text("Flip"),
                  ),
                  Slider(
                    value: size,
                    min: minSize,
                    max: maxSize,
                    onChangeStart: (value) {
                      initialSize = size;
                      initialPosition = position;
                    },
                    onChanged: (value) {
                      setState(() {
                        size = value;
                        position = Offset(
                          initialPosition!.dx + initialSize / 2 - size / 2,
                          initialPosition!.dy + initialSize / 2 - size / 2,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _runGravityAnimation(BuildContext context) {
    final Animation<Offset> gravityAnimation = Tween<Offset>(
            begin: position,
            end: Offset(MediaQuery.of(context).size.width / 2 - size / 2,
                MediaQuery.of(context).size.height / 2 - size / 2))
        .animate(
      CurvedAnimation(parent: _gravityController, curve: Curves.linear),
    );
    gravityAnimation.addListener(() {
      if (_gravityController.status == AnimationStatus.forward) {
        setState(() {
          position = gravityAnimation.value;
        });
      }
    });
    _gravityController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _gravityController.dispose();
    _flipController.dispose();
    super.dispose();
  }
}
