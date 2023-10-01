import 'package:flutter/material.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:flutter_socket/widgets/custom_textfield.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                    shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: 'Create Room',
                    fontSize: 70),
                SizedBox(height: size.height * 0.08),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your nickname',
                  obscure: false,
                ),
                SizedBox(height: size.height * 0.045),
                CustomButton(onTap: () {}, text: 'Create')
              ]),
        ),
      ),
    );
  }
}
