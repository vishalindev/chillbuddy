import 'package:buddy_talk/features/podcast/data/livekit_auth_service.dart';
import 'package:buddy_talk/features/podcast/presentation/models/pod_room.dart';
import 'package:flutter/material.dart';

class JoinPodScreen extends StatefulWidget {
  const JoinPodScreen({super.key});

  @override
  State<JoinPodScreen> createState() => _JoinPodScreenState();
}

class _JoinPodScreenState extends State<JoinPodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  final _authService = LiveKitAuthService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
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

      Navigator.of(context).pop(
        PodRoom(
          roomName: auth.room,
          topic: 'Live Podcast Room',
          host: 'Community Host',
          roomId: auth.room,
          token: auth.token,
          liveKitUrl: auth.liveKitUrl,
          speakers: const ['Host', 'Co-host'],
          listeners: [auth.user, 'Listener 1', 'Listener 2'],
        ),
      );
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
      appBar: AppBar(title: const Text('Join Pod by Room ID')),
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
                decoration: const InputDecoration(labelText: 'Room ID', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter room id' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _join,
                  child: Text(_loading ? 'Authenticating...' : 'Authenticate & Join Podcast'),
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
