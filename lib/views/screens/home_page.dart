import 'package:battleships/views/widgets/app_drawer.dart';
import 'package:battleships/views/screens/play_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../providers/game_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var gameProvider;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? userName = prefs.getString('user_name');
    Provider.of<AuthProvider>(context, listen: false)
        .setAccessToken(accessToken.toString());
    Provider.of<AuthProvider>(context, listen: false)
        .setUserName(userName.toString());
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.fetchGames(context);
  }

  @override
  Widget build(BuildContext context) {
    var showCompletedGames =
        Provider.of<AuthProvider>(context, listen: false).showCompletedGames;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Battleships'),
          ),
          actions: [
            IconButton(
              onPressed: () {
                gameProvider.fetchGames(context);
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            if (gameProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final games = gameProvider.games;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return game.status == 3 || game.status == 0
                    ? showCompletedGames
                        ? Dismissible(
                            key: Key(game.id.toString()),
                            onDismissed: (direction) async {
                              print(game.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Game forfeited',
                                  ),
                                ),
                              );
                              await gameProvider.cancelGame(game.id, context);
                              games.removeAt(index);
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child: const Center(
                                child: Icon(Icons.delete, color: Colors.black),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(PlayGame.route,
                                    arguments: game.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '#${game.id} ${game.status == 3 ? "${game.player1} vs ${game.player2}" : game.status == 0 ? "Waiting for opponent" : ""}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      game.status == 3
                                          ? game.position == game.turn
                                              ? "myTurn"
                                              : "opponentTurn"
                                          : game.status == 0
                                              ? "matchmaking"
                                              : "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                    : showCompletedGames
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(PlayGame.route,
                                  arguments: game.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#${game.id} ${"${game.player1} vs ${game.player2}"}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    game.position == game.status
                                        ? "gameWon"
                                        : "gameLost",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
              },
            );
          },
        ),
      ),
    );
  }
}
