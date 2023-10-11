import 'package:flutter/material.dart';
import 'package:flutter_socket/main.dart';
import 'package:flutter_socket/responsive/responsive.dart';
import 'package:flutter_socket/screens/game_screen.dart';
import 'package:flutter_socket/widgets/custom_button.dart';
import 'package:flutter_socket/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final RealtimeChannel _lobbyChannel;
  var roomName = "Loading ...";
  var gameType = "Loading ...";
  var host = Get.arguments['host'];
  var players = [];
  var hostNickname = "empty";
  var guest = "";
  var guestNickname = "";
  var imGuest = Get.arguments['imGuest'];

  Future<void> getGuestNickName() async {
    if (imGuest) {
      var guestData = await supabase
          .from('profiles')
          .select('nickname')
          .eq('id', supabase.auth.currentUser!.id);
      guestNickname = guestData![0]['nickname'];
    } else {
      guestNickname = "";
    }
  }

  Future<void> getRoomInfo() async {
    var hostData = await supabase
        .from('active_rooms')
        .select('*, profiles(nickname)')
        .eq('host', host);

    roomName = hostData![0]['name'];
    gameType = hostData![0]['game_type'];
    hostNickname = hostData![0]['profiles']['nickname'];

    _lobbyChannel =
        supabase.channel(host, opts: const RealtimeChannelConfig(self: true));
    _lobbyChannel.on(RealtimeListenTypes.presence, ChannelFilter(event: 'sync'),
        (payload, [ref]) {
      final presenceState = _lobbyChannel.presenceState();
      getGuestNickName();
      setState(() {
        players = presenceState.values
            .map((presences) =>
                (presences.first as Presence).payload['player'] as String)
            .toList();

        print('CurrentUsers: $players');

        for (String player in players) {
          if (host != player) {
            guest = player;
            break;
          } else {
            guest = "";
          }
        }
      });
    }).on(RealtimeListenTypes.broadcast, ChannelFilter(event: "game_start"),
        (payload, [_]) {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return GamePage(
      //         host: host,
      //       );
      //     },
      //   ),
      //   (route) => false,
      // );
      Get.offNamed(GameScreen.routeName, arguments: {'host': host});
    }).subscribe((status, [ref]) async {
      if (status == 'SUBSCRIBED') {
        await _lobbyChannel.track({'player': supabase.auth.currentUser?.id});
      }
    });
  }

  Future<void> leaveRoom() async {
    if (imGuest) {
      await supabase
          .from('active_rooms')
          .update({'player': null}).match({'host': host});
    } else {
      await supabase.from('active_rooms').delete().match({'host': host});
    }
    supabase.removeChannel(_lobbyChannel);
  }

  @override
  void initState() {
    print('@@@@@@@@@@@@@@@@@@@: ${Get.arguments}');
    getRoomInfo();
    super.initState();
  }

  @override
  void dispose() {
    leaveRoom();
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
                    ], text: guestNickname, fontSize: 20),
                  ],
                ),
                SizedBox(height: size.height * 0.08),
                CustomButton(
                    onTap: () async {
                      await _lobbyChannel.send(
                          type: RealtimeListenTypes.broadcast,
                          event: 'game_start',
                          payload: {'test': 'test'});
                    },
                    text: 'Start'),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                    onTap: () async {
                      leaveRoom();
                      Get.back();
                    },
                    text: 'Exit'),
              ]),
        ),
      ),
    );
  }
}
