import 'package:battleships/authentication.dart';
import 'package:battleships/place_ships.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _showCompletedGamesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05),
          title: const Text(
            'Which AI do you want to play against?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAIOption('Random', context),
              _buildAIOption('Perfect', context),
              _buildAIOption('One ship (AI)', context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIOption(String option, context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        option,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        print('Selected AI: $option');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Battleships',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
                Text(
                  'Login as michael',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New game'),
            onTap: () {
              Navigator.of(context).pushNamed(PlaceShips.route);
            },
          ),
          ListTile(
            leading: const Icon(Icons.android),
            title: const Text('New game (AI)'),
            onTap: () {
              Navigator.of(context).pop();
              _showCompletedGamesDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Show completed games'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AuthenticationPage.route, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
