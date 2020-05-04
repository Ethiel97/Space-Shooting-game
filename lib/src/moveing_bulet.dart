import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutterbubblegame/src/Provider/ShootingProvider.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class MoveingBulet extends StatefulWidget {
  final left;
  final top;

  final postion;
  Function removeBulet;

  // final left;

  MoveingBulet(
      {this.left,
      this.top,
      @required this.postion,
      @required this.removeBulet});

  @override
  _MoveingBuletState createState() => _MoveingBuletState();
}

class _MoveingBuletState extends State<MoveingBulet>
    with SingleTickerProviderStateMixin {
  AnimationController _moveing_bulet_controller;

  Animation<double> _moveing_bulet_value;

  GlobalKey _bulet_key = GlobalKey();

  bool isShooted = false;

  final assetsAudioPlayer = AssetsAudioPlayer();
  final hitAudio = AssetsAudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadMusic();

    _moveing_bulet_controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _moveing_bulet_value = Tween<double>(begin: widget.top, end: -100)
        .animate(_moveing_bulet_controller)
          ..addListener(() {
            setState(() {});
          });

    _moveing_bulet_controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _moveing_bulet_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShootingProvider>(context);

    if (!provider.game_over) {
      _getPositions(provider);
    }

    return !isShooted
        ? Positioned(
            left: widget.left,
            top: _moveing_bulet_value.value,
            child: Transform.rotate(
                angle: -math.pi,
                child: Container(
                    height: 50,
                    width: 30,
                    child: LayoutBuilder(
                      builder: (context, contain) {
                        return Image(
                          key: _bulet_key,
                          image: AssetImage(
                            "Img/fire.png",
                          ),
                        );
                      },
                    ))),
          )
        : Container();
  }

  _getPositions(ShootingProvider provider) {
    if (_bulet_key.currentWidget != null) {
      final RenderBox object = _bulet_key.currentContext.findRenderObject();
      final positionObject = object.localToGlobal(Offset.zero);
      provider.set_current_bulet_postion(positionObject);

      if (provider.current_object_postion.dx <
              provider.current_bulet_postion.dx &&
          provider.current_object_postion.dx + 120 >
              provider.current_bulet_postion.dx) {
        if (provider.current_bulet_postion.dy <
            provider.current_object_postion.dy + 60) {
          print("Shoteeeeeeeeeeee");

          provider.setScore();

          //audio/shooting_sound.wav
          hitAudio.open(Audio("audio/shooting_sound.wav"));

          hitAudio.play();

          // assetsAudioPlayer.playlistPlayAtIndex(1);

          try {
            setState(() {
              isShooted = true;
            });
          } catch (err) {
            print(err);
          }
        }
      } else if (provider.current_bulet_postion.dy <
          provider.current_object_postion.dy) {
        setState(() {
          isShooted = true;
        });
      }
    }

    //
  }

  void loadMusic() {
    /* assetsAudioPlayer.open(Playlist(audios: [
      Audio("audio/shooting_sound.wav"),
      Audio("audio/hit.wav")
    ]));
*/

    assetsAudioPlayer.open(Audio("audio/hit.wav"));

    assetsAudioPlayer.play();
  }
}
