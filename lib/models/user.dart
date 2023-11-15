import 'package:battleships/models/game.dart';

class User {
  int id;
  String userName;
  Game? game;
  User({
    required this.id,
    required this.userName,
    this.game,
  });
}
