import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:flutter/material.dart';

class CreatePodScreen extends StatefulWidget {
  const CreatePodScreen({super.key});

  @override
  State<CreatePodScreen> createState() => _CreatePodScreenState();
}

class _CreatePodScreenState extends State<CreatePodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomController = TextEditingController();
  final _topicController = TextEditingController();

  @override
  void dispose() {
    _roomController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final room = PodRoom(
      roomName: _roomController.text.trim(),
      topic: _topicController.text.trim(),
      host: 'You',
      speakers: const ['You'],
      listeners: const ['Listener A', 'Listener B', 'Listener C'],
    );
    Navigator.of(context).pop(room);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a New Pod')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room Name', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter room name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter topic' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text('Open Pod Room'))),
            ],
          ),
        ),
      ),
    );
  }
}
