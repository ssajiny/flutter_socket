import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_socket/widgets/roulette/roulette.dart';
import 'package:roulette/roulette.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final _random = Random();

  late RouletteController _controller;

  @override
  void initState() {
    super.initState();

    _controller = RouletteController(
        vsync: this,
        group: RouletteGroup([
          RouletteUnit(
              weight: 1, color: Colors.red.withAlpha(100), text: '× 10'),
          RouletteUnit(
              weight: 1, color: Colors.green.withAlpha(100), text: '× 5'),
          RouletteUnit(
              weight: 1, color: Colors.blue.withAlpha(100), text: '× 3'),
          RouletteUnit(
              weight: 1, color: Colors.yellow.withAlpha(100), text: '× 1'),
          RouletteUnit(
              weight: 1, color: Colors.amber.withAlpha(100), text: 'blank'),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roulette'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            MyRoulette(controller: _controller),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Use the controller to run the animation with rollTo method
        onPressed: () async {
          var roulettValue = (_random.nextDouble() * 5).toInt();
          await _controller.rollTo(
            roulettValue,
            offset: _random.nextDouble(),
          );
          print(roulettValue);
        },
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
