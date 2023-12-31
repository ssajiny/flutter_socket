import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/lobby_screen.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_dropdown.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:flutter_socket/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  String selectedValue = 'One';
  String errorMessage = '';

  Future<void> removeRoom() async {
    await supabase
        .from('active_rooms')
        .delete()
        .match({'host': supabase.auth.currentUser?.id});
  }

  Future<void> createRoom() async {
    await supabase.from('active_rooms').insert({
      'name': _nameController.text,
      'game_type': selectedValue,
      'host': supabase.auth.currentUser!.id,
    });
  }

  @override
  void initState() {
    super.initState();
    removeRoom();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
                    text: 'Create',
                    fontSize: 70),
                SizedBox(height: size.height * 0.04),
                Container(
                  height: size.height * 0.04,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(size.height * 0.02),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Create Name',
                  obscure: false,
                ),
                SizedBox(height: size.height * 0.04),
                CustomDropDown(
                  items: const ['One', 'Two'],
                  initialValue: 'One',
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                    onTap: () async {
                      if (_nameController.text.isEmpty) {
                        errorMessage = "Please enter a name";
                        setState(() {});
                        return;
                      }
                      try {
                        createRoom();
                        Get.offNamed(LobbyScreen.routeName, arguments: {
                          'host': supabase.auth.currentUser!.id,
                          'imGuest': false,
                        });
                      } on PostgrestException catch (_) {
                        errorMessage =
                            "Same name already exists or has already been created";
                      } finally {
                        _nameController.text = '';
                        setState(() {});
                      }
                    },
                    text: 'Create')
              ]),
        ),
      ),
    );
  }
}
