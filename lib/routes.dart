import 'package:battleships/authentication.dart';
import 'package:battleships/home_page.dart';
import 'package:battleships/place_ships.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      AuthenticationPage.route: (context) => AuthenticationPage(),
      HomePage.route: (context) => const HomePage(),
      PlaceShips.route: (context) => const PlaceShips(),
    };
  }
}
