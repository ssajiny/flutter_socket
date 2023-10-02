import 'package:flutter/material.dart';
import 'package:flutter_socket/utils/colors.dart';

class PreviousPage extends StatelessWidget {
  const PreviousPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(bgCololor)),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 25.0,
          )),
    );
  }
}
