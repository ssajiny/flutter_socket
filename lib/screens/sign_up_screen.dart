import 'package:flutter/material.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/login_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:flutter_socket/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _idController.dispose();
    _pwController.dispose();
    _emailController.dispose();
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
                  text: 'Sign Up',
                  fontSize: 70),
              SizedBox(height: size.height * 0.08),
              CustomTextField(
                controller: _idController,
                hintText: 'ID',
                obscure: false,
              ),
              SizedBox(height: size.height * 0.045),
              CustomTextField(
                controller: _pwController,
                hintText: 'Password',
                obscure: true,
              ),
              SizedBox(height: size.height * 0.045),
              CustomTextField(
                controller: _emailController,
                hintText: 'email',
                obscure: false,
              ),
              SizedBox(height: size.height * 0.045),
              CustomButton(onTap: () {}, text: 'Submit'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                      shadows: [Shadow(blurRadius: 1, color: Colors.blue)],
                      text: 'Already a member? ',
                      fontSize: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: bgCololor),
                    child: const Text('Log in'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.routeName);
                    },
                  )
                ],
              ),
            ]),
      )),
    );
  }
}
