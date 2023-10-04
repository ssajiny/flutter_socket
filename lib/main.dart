import 'package:flutter/material.dart';
import 'package:flutter_socket/screens/create_screen.dart';
import 'package:flutter_socket/screens/join_screen.dart';
import 'package:flutter_socket/screens/lobby_screen.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:flutter_socket/screens/sign_up_screen.dart';
import 'package:flutter_socket/screens/splash_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/credential/supabase.dart' as credential;

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: bgCololor),
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        CreateScreen.routeName: (context) => const CreateScreen(),
        JoinScreen.routeName: (context) => const JoinScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        LobbyScreen.routeName: (context) => const LobbyScreen(
              host: '',
            ),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
