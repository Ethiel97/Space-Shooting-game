import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterbubblegame/src/Provider/ShootingProvider.dart';
import 'dart:math' as math;

import 'package:flutterbubblegame/src/moveing_bulet.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class HomePlate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(
      screen_width: MediaQuery.of(context).size.width,
    );
  }
}

class Home extends StatefulWidget {
  final screen_width;

  Home({this.screen_width});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController _moveing_object_controller;

  Animation<double> _movwing_object_value;

  var bulet_number = 5;

  List<MoveingBulet> _moveing_bulet_list = new List();

  // List<AnimatedPositioned> _moveing_bulet = new List();

  /* var objectPositionX;
  var objectPositionY;*/

  Offset _offset;

  GlobalKey _object_key = GlobalKey();

  List<Transform> _bulet = [
    Transform.rotate(
        angle: -math.pi - 1.6,
        child: Container(
            height: 40,
            width: 80,
            child: Image(
              image: AssetImage(
                "Img/fire.png",
              ),
            ))),
    Transform.rotate(
        angle: -math.pi - 1.6,
        child: Container(
            height: 40,
            width: 80,
            child: Image(
              image: AssetImage(
                "Img/fire.png",
              ),
            ))),
    Transform.rotate(
        angle: -math.pi - 1.6,
        child: Container(
            height: 40,
            width: 80,
            child: Image(
              image: AssetImage(
                "Img/fire.png",
              ),
            ))),
    Transform.rotate(
        angle: -math.pi - 1.6,
        child: Container(
            height: 40,
            width: 80,
            child: Image(
              image: AssetImage(
                "Img/fire.png",
              ),
            ))),
    Transform.rotate(
        angle: -math.pi - 1.6,
        child: Container(
            height: 40,
            width: 80,
            child: Image(
              image: AssetImage(
                "Img/fire.png",
              ),
            ))),
  ];

  @override
  void initState() {
    // TODO: implement initState
    //_bulet_moveing_animation_operation(widget.screen_width);

    _moveing_object_animation(widget.screen_width - 80);
    super.initState();
  }

  _getPositions(provider) {
    if (_object_key.currentWidget != null) {
      final RenderBox object = _object_key.currentContext.findRenderObject();
      final positionObject = object.localToGlobal(Offset.zero);

      //print("Current Position   ${positionObject}");
      provider.set_current_object_postion(positionObject);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    //_moveing_gan_controller.dispose();
    //_moveing_gan_controller.dispose();
    _moveing_object_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_bulet.removeLast();

    final provider = Provider.of<ShootingProvider>(context);

    _getPositions(provider);

    _finished_bulet(provider);

    return new Scaffold(
      // key: _object_key,
      body: Stack(
        children: [
          backgroundImg(),
          provider.game_over ? Container() : moveing_bulet(provider),
          provider.game_over ? Container() : moveing_object(),
          provider.game_over ? Container() : bulets(),
          _moveing_bulet_list.length != null
              ? Stack(
                  children: _moveing_bulet_list,
                )
              : Container(),
          provider.game_over
              ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Game Over",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Score : ${provider.score}",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 30,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  backgroundImg() {
    return Image(
        fit: BoxFit.cover,
        image: AssetImage(
          "Img/game_bg.png",
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);
  }

  moveing_bulet(ShootingProvider provider) {
    return Positioned(
      bottom: 10,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 30),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: GestureDetector(
                onHorizontalDragStart: (start) {
                  print("Startttt  ${start.globalPosition}");

                  setState(() {
                    _offset = start.globalPosition;
                  });
                },
                onHorizontalDragUpdate: (update) {
                  print("Startttt  ${update.globalPosition}");

                  setState(() {
                    _offset = update.globalPosition;
                  });
                },
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              // right: 20,
              left: _offset == null ? 20 : _offset.dx,
              child: InkWell(
                onTap: () {
                  if (provider.position == null) {
                    provider.set_postion(0);
                  } else {
                    provider.set_postion(provider.position + 1);
                  }

                  setState(() {
                    _bulet.removeAt(bulet_number - 1);

                    bulet_number = bulet_number - 1;

                    _moveing_bulet_list.add(new MoveingBulet(
                      left: _offset==null ? 20.0 : _offset.dx,
                      top: MediaQuery.of(context).size.height - 100,
                      // postion: provider.position,
                      removeBulet: remove_bulet,
                    ));
                  });
                },
                child: Image(
                  image: AssetImage("Img/ship.png"),
                  width: 40,
                  height: 40,
                ),
              )),
        ],
      ),
    );
  }

  remove_bulet(position) {
    setState(() {
      _moveing_bulet_list.removeAt(position);
    });
  }

  moveing_object() {
    return Positioned(
        top: 20,
        left: _movwing_object_value.value,
        child: Consumer<ShootingProvider>(
          builder: (context, provider, _) {
            return Image(
              key: _object_key,
              image: provider.current_object == 1
                  ? AssetImage("Img/planet_1.png")
                  : provider.current_object == 2
                      ? AssetImage("Img/planet_2.png")
                      : AssetImage("Img/planet_3.png"),
              width: 120,
              height: 120,
            );
          },
        ));
  }

  bulets() {
    return Positioned(
      right: 5,
      bottom: 100,
      child: Column(children: _bulet),
    );
  }

/*  void _bulet_moveing_animation_operation(screen_width) {
    _moveing_gan_controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _movwing_gan_value = Tween<double>(begin: 0, end: screen_width)
        .animate(_moveing_gan_controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _moveing_gan_controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _moveing_gan_controller.forward();
            }
          });

    _moveing_gan_controller.forward();
  }*/

  void _moveing_object_animation(screen_width) {
    _moveing_object_controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _movwing_object_value = Tween<double>(begin: 0, end: screen_width - 40)
        .animate(_moveing_object_controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _moveing_object_controller.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _moveing_object_controller.forward();
            }
          });

    _moveing_object_controller.forward();
  }

  void _finished_bulet(ShootingProvider provider) {
    if (_bulet.length == 0) {
      Timer(Duration(seconds: 2), () {
        print("Yeah, this line is printed after 3 seconds");
        provider.gameOver();
      });
    }
  }
}
