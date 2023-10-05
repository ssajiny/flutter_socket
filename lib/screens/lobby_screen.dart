import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/first_screen.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  final String host;
  final bool imGuest;

  const LobbyScreen({required this.host, super.key, this.imGuest = true});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final RealtimeChannel _lobbyChannel;
  var roomName = "Loading ...";
  var gameType = "Loading ...";
  var players = [];
  var hostNickname = "empty";
  var guest = "";
  var guestNickname = '';

  Future<void> getRoomInfo() async {
    var data = await supabase
        .from('active_rooms')
        .select('*, profiles(nickname)')
        .eq('host', widget.host);
    roomName = data![0]['name'];
    gameType = data![0]['game_type'];
    hostNickname = data![0]['profiles']['nickname'];

    _lobbyChannel = supabase.channel(widget.host,
        opts: const RealtimeChannelConfig(self: true));
    _lobbyChannel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
        (payload, [ref]) {
      final presenceState = _lobbyChannel.presenceState();
      setState(() {
        players = presenceState.values
            .map((presences) =>
                (presences.first as Presence).payload['player'] as String)
            .toList();

        print('CurrentUsers: $players');

        for (String tmp in players) {
          if (tmp != widget.host) {
            guest = tmp;
            break;
          } else {
            guest = "";
          }
        }
        print('I am Guest? ${widget.imGuest}');
      });
    }).on(RealtimeListenTypes.broadcast, ChannelFilter(event: "game_start"),
        (payload, [_]) {
      print('broadcast');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const FirstScreen();
          },
        ),
        (route) => false,
      );
    }).subscribe((status, [ref]) async {
      if (status == 'SUBSCRIBED') {
        await _lobbyChannel.track({'player': supabase.auth.currentUser?.id});
      }
    });
  }

  Future<void> leaveRoom() async {
    await supabase
        .from('active_rooms')
        .delete()
        .match({'host': supabase.auth.currentUser?.id});
    supabase.removeChannel(_lobbyChannel);
  }

  @override
  void initState() {
    getRoomInfo();
    super.initState();
  }

  @override
  void dispose() {
    supabase.removeChannel(_lobbyChannel);
    super.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(shadows: const [
                      Shadow(blurRadius: 40, color: Colors.blue)
                    ], text: roomName, fontSize: 30),
                    CustomText(shadows: const [
                      Shadow(blurRadius: 40, color: Colors.blue)
                    ], text: gameType, fontSize: 30),
                  ],
                ),
                SizedBox(height: size.height * 0.1),
                Row(
                  children: [
                    const CustomText(
                        shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                        text: 'Host',
                        fontSize: 20),
                    const Spacer(),
                    CustomText(shadows: const [
                      Shadow(blurRadius: 40, color: Colors.blue)
                    ], text: hostNickname, fontSize: 20),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  children: [
                    const CustomText(
                        shadows: [Shadow(blurRadius: 40, color: Colors.blue)],
                        text: 'Guest',
                        fontSize: 20),
                    const Spacer(),
                    CustomText(shadows: const [
                      Shadow(blurRadius: 40, color: Colors.blue)
                    ], text: guest, fontSize: 20),
                  ],
                ),
                SizedBox(height: size.height * 0.08),
                CustomButton(
                    onTap: () async {
                      await _lobbyChannel.send(
                          type: RealtimeListenTypes.broadcast,
                          event: 'game_start',
                          payload: {'test': 'test'});
                      leaveRoom();
                    },
                    text: 'Start'),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                    onTap: () async {
                      leaveRoom();
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    text: 'Exit'),
              ]),
        ),
      ),
    );
  }
}
