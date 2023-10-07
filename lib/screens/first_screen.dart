import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/screens/main_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late final RealtimeChannel _gameChannel;

  @override
  void initState() {
    super.initState();
    _gameChannel =
        supabase.channel('test', opts: const RealtimeChannelConfig(self: true));
    _gameChannel.on(RealtimeListenTypes.broadcast, ChannelFilter(event: "end"),
        (payload, [_]) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const MainMenuScreen();
          },
        ),
        (route) => false,
      );
    }).subscribe((status, [ref]) async {
      if (status == 'SUBSCRIBED') {
        await _gameChannel.track({'player': supabase.auth.currentUser?.id});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              await _gameChannel.send(
                  type: RealtimeListenTypes.broadcast,
                  event: 'end',
                  payload: {'test': 'test'});
            },
            child: const Text('Exit')),
      ),
    );
  }
}
