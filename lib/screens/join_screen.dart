import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/lobby_screen.dart';
import 'package:flutter_socket/utils/check_session.dart';
import 'package:flutter_socket/utils/colors.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_table.dart';
import 'package:flutter_socket/widgets/custom_text.dart';

class JoinScreen extends StatefulWidget {
  static String routeName = '/join-room';
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  late final list;
  List<dynamic> selected = [];

  Future<void> getRoomInfo() async {
    list = supabase
        .from('active_rooms')
        .select<List<Map<String, dynamic>>>('*, profiles(nickname)');
  }

  Future<bool> checkStatus() async {
    var status = await supabase
        .from('active_rooms')
        .select('player')
        .eq('host', selected[0]['host']);
    return status[0]['player'].toString() == "null";
  }

  @override
  void initState() {
    checkSession(context);
    getRoomInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: list,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        height: 250,
                        child: CustomTable(
                          dataList: snapshot.data ?? [],
                          onChanged: (selectedRow) {
                            selected = selectedRow;
                          },
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: size.height * 0.045),
                CustomButton(
                    onTap: () async {
                      if (selected.isNotEmpty && await checkStatus()) {
                        await supabase.from('active_rooms').update({
                          'player': supabase.auth.currentUser!.id
                        }).match({'host': selected[0]['host']});

                        Future.delayed(Duration.zero, () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LobbyScreen(host: selected[0]['host'])));
                        });
                      }
                    },
                    text: 'Join'),
              ]),
        ),
      ),
    );
  }
}
