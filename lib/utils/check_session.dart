import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/screens/login_screen.dart';

Future<void> checkSession(BuildContext context) async {
  final session = supabase.auth.currentSession;
  if (session == null) {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }
}
