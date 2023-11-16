import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _accessToken;
  String? _userName;
  bool _showCompletedGames = true;

  String? get accessToken => _accessToken;
  String? get userName => _userName;
  bool get showCompletedGames => _showCompletedGames;

  void setAccessToken(String? token) {
    _accessToken = token;
    notifyListeners();
  }

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setShowGameString(bool showCompletedGames) {
    _showCompletedGames = showCompletedGames;
    notifyListeners();
  }

  void toggle() {
    _showCompletedGames = !_showCompletedGames;
    notifyListeners();
  }
}
