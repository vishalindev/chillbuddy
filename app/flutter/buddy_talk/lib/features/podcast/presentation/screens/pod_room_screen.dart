import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:flutter/material.dart';

class PodRoomScreen extends StatelessWidget {
  const PodRoomScreen({super.key, required this.room});

  final PodRoom room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(room.roomName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(room.topic),
              subtitle: Text('Host: ${room.host}'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Hop On Stage')),
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
