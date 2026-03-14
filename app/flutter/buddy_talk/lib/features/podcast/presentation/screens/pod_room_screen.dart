import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:flutter/material.dart';

class PodRoomScreen extends StatelessWidget {
  const PodRoomScreen({super.key, required this.room});

  final PodRoom room;

  String _maskedToken(String? token) {
    if (token == null || token.isEmpty) return 'No token yet';
    if (token.length <= 14) return token;
    return '${token.substring(0, 8)}...${token.substring(token.length - 6)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(room.roomName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.topic, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Host: ${room.host}'),
                  Text('Room ID: ${room.roomId}'),
                  Text('LiveKit URL: ${room.liveKitUrl ?? 'wss://rtc.sharkdigital.ai'}'),
                  Text('Token: ${_maskedToken(room.token)}'),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: const Text('Hop On Stage')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Speakers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ...room.speakers.map((s) => Card(child: ListTile(leading: const Icon(Icons.mic), title: Text(s)))),
          const SizedBox(height: 12),
          const Text('Listeners', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ...room.listeners.map((l) => Card(child: ListTile(leading: const Icon(Icons.headset), title: Text(l)))),
        ],
      ),
    );
  }
}
