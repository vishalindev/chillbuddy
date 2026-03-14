import 'package:flutter/foundation.dart';

enum CallUiState {
  idle,
  signaling,
  nativeIncoming,
  ringing,
  connecting,
  inCall,
  ended,
}

class IncomingCallEvent {
  const IncomingCallEvent({required this.callId, required this.callerName});

  final String callId;
  final String callerName;
}

class CallProvider extends ChangeNotifier {
  CallUiState state = CallUiState.idle;
  String? activeCallId;

  /// Background/terminated flow:
  /// 1) Push arrives via FCM/APNs with call metadata.
  /// 2) Native layer triggers CallKit (iOS) / ConnectionService (Android).
  /// 3) User accepts/rejects on native incoming UI.
  /// 4) App boots isolate, restores session, opens WebSocket signaling.
  /// 5) WebRTC offer/answer exchange, audio route configured.
  /// 6) Transition to in-call screen.
  Future<void> onIncomingCall(IncomingCallEvent event) async {
    state = CallUiState.nativeIncoming;
    activeCallId = event.callId;
    notifyListeners();
  }

  Future<void> acceptFromNativeUi() async {
    state = CallUiState.connecting;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    state = CallUiState.inCall;
    notifyListeners();
  }

  void rejectFromNativeUi() {
    state = CallUiState.ended;
    activeCallId = null;
    notifyListeners();
  }
}
