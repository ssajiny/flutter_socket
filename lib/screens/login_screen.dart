import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:flutter_socket/screens/sign_up_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:flutter_socket/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  void signInWithPassword() async {
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _pwController.text.trim(),
      );
    } on AuthException catch (error) {
      print('Login error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
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
                  text: 'Login',
                  fontSize: 70),
              CustomTextField(
                controller: _emailController,
                hintText: 'e-mail',
                obscure: false,
              ),
              SizedBox(height: size.height * 0.045),
              CustomTextField(
                controller: _pwController,
                hintText: 'Password',
                obscure: true,
              ),
              SizedBox(height: size.height * 0.045),
              CustomButton(
                  onTap: () async {
                    signInWithPassword();
                    Get.offNamed(MainMenuScreen.routeName);
                  },
                  text: 'Login'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                      shadows: [Shadow(blurRadius: 1, color: Colors.blue)],
                      text: 'Don\'t have an account? ',
                      fontSize: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: bgCololor),
                    child: const Text('Sign Up'),
                    onPressed: () {
                      Get.toNamed(SignUpScreen.routeName);
                    },
                  )
                ],
              ),
            ]),
      )),
    );
  }
}
