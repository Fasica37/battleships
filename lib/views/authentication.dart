import 'package:battleships/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({super.key});
  static const route = '/authentication';

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    String errorMessage = '';
    if (username.length < 3) {
      errorMessage = 'Username must be at least 3 characters long';
    } else if (password.length < 3) {
      errorMessage = 'Password must be at least 3 characters long';
    } else if (username.contains(' ')) {
      errorMessage = 'Username cannot contain spaces';
    } else if (password.contains(' ')) {
      errorMessage = 'Password cannot contain spaces';
    }
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
        ),
      ));
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final authService = AuthService();
      final response = await authService.loginUser(username, password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', response.accessToken);
      prefs.setString('user_name', username);

      Provider.of<AuthProvider>(context, listen: false)
          .setAccessToken(response.accessToken);
      Provider.of<AuthProvider>(context, listen: false).setUserName(username);
      Provider.of<AuthProvider>(context, listen: false).setShowGameString(true);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.route, (route) => false);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception:')) {
        errorMessage = errorMessage.substring('Exception:'.length).trim();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  Future<void> register(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    String errorMessage = '';
    if (username.length < 3) {
      errorMessage = 'Username must be at least 3 characters long';
    } else if (password.length < 3) {
      errorMessage = 'Password must be at least 3 characters long';
    } else if (username.contains(' ')) {
      errorMessage = 'Username cannot contain spaces';
    } else if (password.contains(' ')) {
      errorMessage = 'Password cannot contain spaces';
    }
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
        ),
      ));
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final authService = AuthService();
      final response = await authService.registerUser(username, password);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', response.accessToken);

      Provider.of<AuthProvider>(context, listen: false)
          .setAccessToken(response.accessToken);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.route, (route) => false);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception:')) {
        errorMessage = errorMessage.substring('Exception:'.length).trim();
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: MediaQuery.sizeOf(context).width * 0.5,
          backgroundColor: Colors.grey[100],
          behavior: SnackBarBehavior.floating,
          content: Container(
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Press again to exit',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Login'),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => login(context),
                          child: Text('Log In'),
                        ),
                        TextButton(
                          onPressed: () => register(context),
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
