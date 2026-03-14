import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:buddy_talk/features/podcast/presentation/screens/create_pod_screen.dart';
import 'package:buddy_talk/features/podcast/presentation/screens/join_pod_screen.dart';
import 'package:buddy_talk/features/podcast/presentation/screens/pod_room_screen.dart';
import 'package:flutter/material.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({super.key});

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  final rooms = <PodRoom>[
    const PodRoom(
      roomName: 'English Fast Practice',
      topic: 'Daily speaking drills',
      host: 'Aarav',
      roomId: 'english-fast-practice',
      speakers: ['Aarav', 'Mina', 'Sam'],
      listeners: ['L1', 'L2', 'L3', 'L4'],
    ),
    const PodRoom(
      roomName: 'Travel Stories',
      topic: 'Airport + hotel conversations',
      host: 'Mila',
      roomId: 'travel-stories',
      speakers: ['Mila', 'Ryo'],
      listeners: ['Nina', 'Karan'],
    ),
  ];

  Future<void> _createPod() async {
    final room = await Navigator.of(context).push<PodRoom>(
      MaterialPageRoute(builder: (_) => const CreatePodScreen()),
    );
    if (room != null) {
      setState(() => rooms.insert(0, room));
      if (!mounted) return;
      _openRoom(room);
    }
  }

  Future<void> _joinByRoomId() async {
    final room = await Navigator.of(context).push<PodRoom>(
      MaterialPageRoute(builder: (_) => const JoinPodScreen()),
    );
    if (room != null) {
      if (!mounted) return;
      _openRoom(room);
    }
  }

  void _openRoom(PodRoom room) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PodRoomScreen(room: room)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _createPod,
            icon: const Icon(Icons.add_circle),
            label: const Text('Create a New Pod'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _joinByRoomId,
            icon: const Icon(Icons.meeting_room),
            label: const Text('Join Podcast by Room ID'),
          ),
        ),
        const SizedBox(height: 16),
        ...rooms.map(
          (room) => Card(
            child: ListTile(
              title: Text(room.roomName),
              subtitle: Text('${room.topic}\nRoom ID: ${room.roomId} • ${room.listeners.length} listeners'),
              isThreeLine: true,
              trailing: ElevatedButton(onPressed: () => _openRoom(room), child: const Text('Join')),
            ),
          ),
        ),
      ],
    );
  }
}
