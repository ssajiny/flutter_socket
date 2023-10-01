import 'package:flutter/material.dart';
import 'package:flutter_socket/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.blue,
          blurRadius: 5,
          spreadRadius: 2,
        )
      ]),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        decoration: InputDecoration(
          fillColor: bgCololor,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
