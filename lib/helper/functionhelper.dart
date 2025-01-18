import 'package:supabase_flutter/supabase_flutter.dart';

test(String subdomain) {
  final client = Supabase.instance.client;
  client.functions.invoke('create-sub-domain', body: {
    'sub': subdomain,
    'token': client.auth.currentSession?.refreshToken
  }, headers: {
    'Authorization': 'Bearer ${client.auth.currentSession?.accessToken}'
  }).then((val) {
    return val.status;
  });
}
