import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket/screens/ace_skies.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final AceSkies _aceSkies;

  @override
  void initState() {
    super.initState();
    _aceSkies = AceSkies();
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
