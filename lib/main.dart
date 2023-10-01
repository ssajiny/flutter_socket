import 'package:flutter/material.dart';
import 'package:flutter_socket/screens/create_room_screen.dart';
import 'package:flutter_socket/screens/join_room_screen.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:flutter_socket/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgCololor),
      routes: {
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
        CreateRoomScreen.routeName: (context) => const JoinRoomScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }
}
