import 'package:flutter/material.dart';

class PodcastScreen extends StatelessWidget {
  const PodcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rooms = <Map<String, String>>[
      {'name': 'English Fast Practice', 'host': 'Aarav', 'listeners': '41'},
      {'name': 'Travel Stories', 'host': 'Mila', 'listeners': '28'},
      {'name': 'Job Interview Prep', 'host': 'Ravi', 'listeners': '16'},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.mic),
            label: const Text('Host Live Room'),
          ),
        ),
        const SizedBox(height: 16),
        ...rooms.map(
          (room) => Card(
            child: ListTile(
              title: Text(room['name']!),
              subtitle: Text('Host: ${room['host']} • ${room['listeners']} listening'),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Join')),
            ),
          ),
        ),
      ],
    );
  }
}
