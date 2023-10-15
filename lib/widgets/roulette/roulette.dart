import 'package:flutter/material.dart';
import 'package:flutter_socket/widgets/roulette/arrow.dart';
import 'package:roulette/roulette.dart';

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Roulette(
              // Provide controller to update its state
              controller: controller,
              // Configure roulette's appearance
              style: const RouletteStyle(
                  dividerThickness: 2.5,
                  dividerColor: Colors.black,
                  centerStickSizePercent: 0.03,
                  centerStickerColor: Colors.black,
                  textStyle: TextStyle(fontSize: 20)),
            ),
          ),
        ),
        const Arrow(),
      ],
    );
  }
}
