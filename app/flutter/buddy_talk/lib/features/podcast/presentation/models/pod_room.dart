class PodRoom {
  const PodRoom({
    required this.roomName,
    required this.topic,
    required this.host,
    required this.roomId,
    this.token,
    this.liveKitUrl,
    this.speakers = const <String>[],
    this.listeners = const <String>[],
  });

  final String roomName;
  final String topic;
  final String host;
  final String roomId;
  final String? token;
  final String? liveKitUrl;
  final List<String> speakers;
  final List<String> listeners;
}
