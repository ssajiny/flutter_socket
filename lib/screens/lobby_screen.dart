import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';

  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  var roomName = "Loading ...";

  Future<void> getRoomName() async {
    await Future.delayed(Duration.zero);
    var data = await supabase.from('active_rooms').select('name');
    roomName = data[0]['name'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRoomName();
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
                CustomText(
                    shadows: const [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: roomName,
                    fontSize: 30),
                SizedBox(height: size.height * 0.08),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                    onTap: () async {
                      await supabase
                          .from('active_rooms')
                          .delete()
                          .match({'manager': supabase.auth.currentUser?.id});
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    text: 'Exit')
              ]),
        ),
      ),
    );
  }
}
