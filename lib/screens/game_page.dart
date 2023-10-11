import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/screens/ace_skies.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GamePage extends StatefulWidget {
  static String routeName = '/game-page';
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final AceSkies _aceSkies;
  var host = Get.arguments['host'];
  RealtimeChannel? _gameChannel;

  Future<void> _initialize() async {
    _aceSkies = AceSkies(
      // Callback to notify the parent when the game ends.
      onGameStateUpdate: (position, health) async {
        ChannelResponse response;
        do {
          response = await _gameChannel!.send(
            type: RealtimeListenTypes.broadcast,
            event: 'game_state',
            payload: {'x': position.x, 'y': position.y, 'health': health},
          );
          await Future.delayed(Duration.zero);
          setState(() {});
        } while (response == ChannelResponse.rateLimited && health <= 0);
      },

      // Callback for when the game state updates.
      onGameOver: (playerWon) async {
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: Text(playerWon ? 'You Won!' : 'You Lost...'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Get.offAllNamed(MainMenuScreen.routeName);
                        await supabase.removeChannel(_gameChannel!);
                      },
                      child: const Text('Back to Lobby'))
                ],
              );
            }));
      },
    );
    // await for a frame so that the widget mounts
    await Future.delayed(Duration.zero);

    if (mounted) {
      _openGame();
    }
  }

  void _openGame() async {
    await Future.delayed(Duration.zero);
    _aceSkies.startNewGame();

    _gameChannel =
        supabase.channel(host, opts: const RealtimeChannelConfig(ack: true));

    _gameChannel!
        .on(RealtimeListenTypes.broadcast, ChannelFilter(event: 'game_state'),
            (payload, [_]) {
      final position = Vector2(payload['x'] as double, payload['y'] as double);
      final opponentHealth = payload['health'] as int;
      _aceSkies.updateOpponent(position: position, health: opponentHealth);

      if (opponentHealth <= 0) {
        if (!_aceSkies.isGameOver) {
          _aceSkies.isGameOver = true;
          _aceSkies.onGameOver(true);
        }
      }
    }).subscribe();
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [GameWidget(game: _aceSkies)],
      ),
    );
  }
}
