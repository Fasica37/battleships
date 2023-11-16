import 'dart:convert';
import 'package:battleships/common/const.dart';
import 'package:http/http.dart' as http;

import '../models/auth_response.dart';

class AuthService {
  Future<AuthResponse> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Const.baseUrl}/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      throw Exception('Registration failed');
    }
  }

  Future<AuthResponse> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Const.baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AuthResponse.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }
}
