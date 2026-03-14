class PodRoom {
  const PodRoom({
    required this.roomName,
    required this.topic,
    required this.host,
    this.speakers = const <String>[],
    this.listeners = const <String>[],
  });

  final String roomName;
  final String topic;
  final String host;
  final List<String> speakers;
  final List<String> listeners;
}
