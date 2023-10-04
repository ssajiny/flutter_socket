import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  final String host;

  const LobbyScreen({required this.host, super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final RealtimeChannel _lobbyChannel;
  var roomName = "Loading ...";
  var players = [];
  var player = "empty";

  Future<void> getRoomName() async {
    var data =
        await supabase.from('active_rooms').select().eq('host', widget.host);
    roomName = data[0]['name'];
    setState(() {});

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
        print('@@@@@@@@@: $players');
        for (String tmp in players) {
          if (tmp != widget.host) {
            player = tmp;
            break;
          } else {
            player = "empty";
          }
        }
      });
    }).on(RealtimeListenTypes.broadcast, ChannelFilter(event: "game_start"),
        (payload, [_]) {
      // final participantIds = List<String>.from(payload["participants"]);
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
  }

  @override
  void initState() {
    getRoomName();
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
                CustomText(
                    shadows: const [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: roomName,
                    fontSize: 30),
                CustomText(
                    shadows: const [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: widget.host,
                    fontSize: 20),
                CustomText(
                    shadows: const [Shadow(blurRadius: 40, color: Colors.blue)],
                    text: player,
                    fontSize: 20),
                SizedBox(height: size.height * 0.08),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                    onTap: () async {
                      // leaveRoom();
                      // if (!mounted) return;
                      // Navigator.of(context).pop();
                      await _lobbyChannel.send(
                          type: RealtimeListenTypes.broadcast,
                          event: 'game_start',
                          payload: {'test': 'test'});
                    },
                    text: 'Exit')
              ]),
        ),
      ),
    );
  }
}
