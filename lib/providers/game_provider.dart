import 'dart:convert';

import 'package:battleships/common/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game.dart';
import '../models/game_details.dart';
import '../models/game_start_response.dart';
import '../models/shop_response.dart';
import '../views/screens/authentication.dart';

class GameProvider extends ChangeNotifier {
  List<Game> _games = [];
  bool _isLoading = false;
  GameDetails? _gameDetails;

  List<Game> get games => _games;
  bool get isLoading => _isLoading;
  GameDetails? get gameDetails => _gameDetails;

  Future<void> fetchGames(BuildContext context) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('${Const.baseUrl}/games'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final List<dynamic> gamesData = jsonDecode(response.body)['games'];
      _games = gamesData.map((game) => Game.fromJson(game)).toList();
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token has expired. Please login again.'),
      ));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthenticationPage.route, (route) => false);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<GameStartResponse?> startGame(List<String> ships, BuildContext context,
      {String? ai}) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final Map<String, dynamic> requestBody = ai == null
        ? {
            'ships': ships,
          }
        : {
            'ships': ships,
            'ai': ai,
          };

    final response = await http.post(
      Uri.parse('${Const.baseUrl}/games'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(requestBody),
    );
    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return GameStartResponse.fromJson(responseData);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token has expired. Please login again.'),
      ));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthenticationPage.route, (route) => false);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
    return null;
  }

  Future<void> getGameDetails(int gameId, BuildContext context) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final response = await http.get(
      Uri.parse('${Const.baseUrl}/games/$gameId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      _gameDetails = GameDetails.fromJson(responseData);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token has expired. Please login again.'),
      ));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthenticationPage.route, (route) => false);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<ShotResponse?> playShot(
      int gameId, String shot, BuildContext context) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final response = await http.put(
      Uri.parse('${Const.baseUrl}/games/$gameId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode({'shot': shot}),
    );

    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return ShotResponse.fromJson(responseData);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token has expired. Please login again.'),
      ));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthenticationPage.route, (route) => false);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<void> cancelGame(int gameId, BuildContext context) async {
    _isLoading = true;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    final response = await http.delete(
      Uri.parse('${Const.baseUrl}/games/$gameId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    _isLoading = false;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Token has expired. Please login again.'),
      ));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AuthenticationPage.route, (route) => false);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }
}
