import 'dart:convert';

import 'package:http/http.dart' as http;

class LiveKitAuthResult {
  const LiveKitAuthResult({
    required this.user,
    required this.room,
    required this.token,
    required this.liveKitUrl,
  });

  final String user;
  final String room;
  final String token;
  final String liveKitUrl;
}

class LiveKitAuthService {
  static const String api = 'https://apivani.sharkdigital.ai/get_token_autenticated';
  static const String liveKit = 'wss://rtc.sharkdigital.ai';

  Future<LiveKitAuthResult> authenticate({required String user, required String room}) async {
    final response = await http.post(
      Uri.parse(api),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'user': user, 'room': room}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Authentication failed (${response.statusCode}): ${response.body}');
    }

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected auth response format');
    }

    final token = (data['token'] ?? data['accessToken'] ?? data['jwt'] ?? '').toString();
    final resolvedUser = (data['user'] ?? user).toString();
    final resolvedRoom = (data['room'] ?? room).toString();

    if (token.isEmpty) {
      throw Exception('Token missing in auth response');
    }

    return LiveKitAuthResult(
      user: resolvedUser,
      room: resolvedRoom,
      token: token,
      liveKitUrl: liveKit,
    );
  }
}
