import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/create_room_screen.dart';
import 'package:flutter_socket/screens/join_room_screen.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/widgets/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({super.key});

  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomButton(
                onTap: () async {
                  // createRoom(context);
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                  await supabase.auth.signOut();
                },
                text: 'Create Room'),
            const SizedBox(
              height: 30,
            ),
            CustomButton(onTap: () => joinRoom(context), text: 'Join Room'),
          ]),
        ),
      ),
    );
  }
}
