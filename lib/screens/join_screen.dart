import 'package:flutter/material.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/utils/check_session.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:flutter_socket/widgets/custom_textfield.dart';

class JoinScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkSession(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _gameIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgCololor,
      ),
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                    shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: 'Join',
                    fontSize: 70),
                SizedBox(height: size.height * 0.08),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your nickname',
                  obscure: false,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _gameIdController,
                  hintText: 'Enter Game ID',
                  obscure: false,
                ),
                SizedBox(height: size.height * 0.045),
                CustomButton(onTap: () {}, text: 'Join'),
              ]),
        ),
      ),
    );
  }
}
