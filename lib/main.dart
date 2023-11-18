import 'package:battleships/views/screens/authentication.dart';
import 'package:battleships/config/routes.dart';
import 'package:battleships/views/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/game_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<GameProvider>(
          create: (context) => GameProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Battleships',
        home: accessToken == null || accessToken.isEmpty
            ? AuthenticationPage()
            : const HomePage(),
        routes: Routes.getRoute(),
      ),
    ),
  );
}
