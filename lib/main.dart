import 'package:flutter/material.dart';
import 'package:flutter_socket/screens/create_room_screen.dart';
import 'package:flutter_socket/screens/join_room_screen.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:flutter_socket/screens/sign_up_screen.dart';
import 'package:flutter_socket/screens/splash_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/assets/constants.dart' as constants;

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: constants.url,
    anonKey: constants.anonKey,
    realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 40),
    authFlowType: AuthFlowType.pkce,
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
        CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
        JoinRoomScreen.routeName: (context) => const JoinRoomScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
