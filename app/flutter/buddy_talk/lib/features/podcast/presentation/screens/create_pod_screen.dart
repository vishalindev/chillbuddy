import 'package:buddy_talk/features/podcast/data/livekit_auth_service.dart';
import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:flutter/material.dart';

class CreatePodScreen extends StatefulWidget {
  const CreatePodScreen({super.key});

  @override
  State<CreatePodScreen> createState() => _CreatePodScreenState();
}

class _CreatePodScreenState extends State<CreatePodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  final _topicController = TextEditingController();
  final _authService = LiveKitAuthService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final auth = await _authService.authenticate(
        user: _nameController.text.trim(),
        room: _roomController.text.trim(),
      );
      if (!mounted) return;

      final room = PodRoom(
        roomName: _roomController.text.trim(),
        topic: _topicController.text.trim(),
        host: auth.user,
        roomId: auth.room,
        token: auth.token,
        liveKitUrl: auth.liveKitUrl,
        speakers: [auth.user],
        listeners: const ['Listener A', 'Listener B', 'Listener C'],
      );

      Navigator.of(context).pop(room);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create a New Pod')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roomController,
                decoration: const InputDecoration(labelText: 'Room ID / Room Name', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter room id' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter topic' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_loading ? 'Authenticating...' : 'Authenticate & Open Pod'),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
