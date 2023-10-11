import 'package:flutter/material.dart';
import 'package:flutter_socket/screens/game_screen.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:flutter_socket/screens/create_screen.dart';
import 'package:flutter_socket/screens/join_screen.dart';
import 'package:flutter_socket/screens/lobby_screen.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/screens/sign_up_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/screens/splash_screen.dart';
import 'package:flutter_socket/credential/supabase.dart' as credential;
import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: credential.url,
    anonKey: credential.anonKey,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 40),
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SJH Socket',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgCololor),
      getPages: [
        GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
        GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
        GetPage(name: SignUpScreen.routeName, page: () => const SignUpScreen()),
        GetPage(
            name: MainMenuScreen.routeName, page: () => const MainMenuScreen()),
        GetPage(name: CreateScreen.routeName, page: () => const CreateScreen()),
        GetPage(name: JoinScreen.routeName, page: () => const JoinScreen()),
        GetPage(name: LobbyScreen.routeName, page: () => const LobbyScreen()),
        GetPage(name: GameScreen.routeName, page: () => const GameScreen()),
      ],
      home: const SplashScreen(),
    );
  }
}
