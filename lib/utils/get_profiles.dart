import 'package:flutter_socket/main.dart';

Future<String> getNickName(String uuid) async {
  var nickName =
      await supabase.from('profiles').select('nickname').eq('id', uuid);
  return (nickName[0]['nickname']);
}
