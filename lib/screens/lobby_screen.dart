import 'package:flutter/material.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                    shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: 'Create Game',
                    fontSize: 30),
                SizedBox(height: size.height * 0.08),
                SizedBox(height: size.height * 0.04),
                CustomButton(onTap: () async {}, text: 'Exit')
              ]),
        ),
      ),
    );
  }
}
