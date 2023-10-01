import 'package:flutter/material.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/create_room_screen.dart';
import 'package:flutter_socket/screens/join_room_screen.dart';
import 'package:flutter_socket/widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';

  const MainMenuScreen({super.key});

  void CreateRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void JoinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomButton(onTap: () => CreateRoom(context), text: 'Create Room'),
            const SizedBox(
              height: 30,
            ),
            CustomButton(onTap: () => JoinRoom(context), text: 'Join Room'),
          ]),
        ),
      ),
    );
  }
}
