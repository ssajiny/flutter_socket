import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/create_screen.dart';
import 'package:flutter_socket/screens/join_screen.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/utils/check_session.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:get/get.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({super.key});

  void createRoom(BuildContext context) {
    Get.toNamed(CreateScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Get.toNamed(JoinScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    checkSession(context);
    return Scaffold(
      body: Responsive(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomButton(
                onTap: () async {
                  createRoom(context);
                },
                text: 'Create'),
            const SizedBox(
              height: 30,
            ),
            CustomButton(onTap: () => joinRoom(context), text: 'Join'),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                onTap: () async {
                  await supabase.auth.signOut();
                  Get.offAllNamed(LoginScreen.routeName);
                },
                text: 'Log out'),
          ]),
        ),
      ),
    );
  }
}
