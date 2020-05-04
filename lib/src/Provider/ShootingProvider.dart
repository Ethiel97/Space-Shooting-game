import 'package:flutter/widgets.dart';

class ShootingProvider extends ChangeNotifier {
  var _current_object;

  var _position;
  bool _game_over;
  int _score;

  int get score => _score;

  get game_over => _game_over;

  get position => _position;

  Offset _current_object_postion;

  Offset _current_bulet_postion;

  get current_object => _current_object;

  Offset get current_object_postion => _current_object_postion;

  Offset get current_bulet_postion => _current_bulet_postion;

  ShootingProvider() {
    _current_object = 1;
    _game_over = false;
    _score = 0;

    //notifyListeners();
  }

  setScore() {
    _score = _score + 1;

    print("Scoreeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  ${_score}");
  }

  set_postion(v) {
    _position = v;
    notifyListeners();
  }

  delete_position() {
    _position - 1;
    notifyListeners();
  }

  set_current_object(value) {
    _current_object = value;

    //notifyListeners();
  }

  set_current_object_postion(value) {
    _current_object_postion = value;

    // notifyListeners();
  }

  set_current_bulet_postion(value) {
    _current_bulet_postion = value;

    print(
        "Object postion ${current_object_postion}  and Bulet postion ${_current_bulet_postion}");

    if (current_object_postion.dx < current_bulet_postion.dx &&
        current_object_postion.dx + 120 > current_bulet_postion.dx) {
      if (current_bulet_postion.dy < current_object_postion.dy + 60) {
        print(
            "Shotting Object ${current_object_postion} and Bulet ${current_bulet_postion}");

        switchObject();
      }
    }

    //notifyListeners();
  }

  void switchObject() {
    switch (_current_object) {
      case 1:
        set_current_object(2);
        break;

      case 2:
        set_current_object(3);
        break;

      case 3:
        gameOver();

        break;
    }
  }

  void gameOver() {
    _game_over = true;

    //notifyListeners();
  }
}
