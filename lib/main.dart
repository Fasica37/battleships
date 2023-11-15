import 'package:battleships/authentication.dart';
import 'package:battleships/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battleships',
      home: AuthenticationPage(),
      routes: Routes.getRoute(),
    ),
  );
}
