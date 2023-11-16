import 'package:battleships/views/authentication.dart';
import 'package:battleships/views/home_page.dart';
import 'package:battleships/views/place_ships.dart';
import 'package:battleships/views/play_game.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      AuthenticationPage.route: (context) => AuthenticationPage(),
      HomePage.route: (context) => const HomePage(),
      PlaceShips.route: (context) => const PlaceShips(),
      PlayGame.route: (context) => const PlayGame(),
    };
  }
}
