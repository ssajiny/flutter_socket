import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    final session = supabase.auth.currentSession;

    if (!mounted) return;
    if (session != null) {
      Get.offNamed(MainMenuScreen.routeName);
    } else {
      Get.offNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
