import 'package:college_cupid/services/websocket_service.dart';

class SpeedDatingRepository {
  final WebSocketService _webSocketService = WebSocketService();

  // Singleton pattern
  static final SpeedDatingRepository _instance =
      SpeedDatingRepository._internal();
  factory SpeedDatingRepository() => _instance;
  SpeedDatingRepository._internal();

  Stream<Map<String, dynamic>> get chatMessageStream =>
      _webSocketService.chatMessageStream;
  Stream<String> get continueResponseStream =>
      _webSocketService.continueResponseStream;
  Stream<void> get chatClosedStream => _webSocketService.chatClosedStream;
  Stream<void> get partnerLeftStream => _webSocketService.partnerLeftStream;
  Stream<void> get partnerDisconnectedStream =>
      _webSocketService.partnerDisconnectedStream;
  Stream<Map<String, dynamic>> get roomCreatedStream =>
      _webSocketService.roomCreatedStream;
  Stream<void> get disconnectedStream => _webSocketService.disconnectedStream;

  void connect() {
    _webSocketService.initConnection();
  }

  void joinPool({
    required String email,
    required int gender,
    required List<String> interests,
  }) {
    _webSocketService.joinPool(
      email,
      gender,
      interests,
      DateTime.now().toIso8601String(),
    );
  }

  void sendMessage(String roomId, String message) {
    _webSocketService.sendChatMessage(roomId, message);
  }

  void sendDecision(String roomId, String answer) {
    _webSocketService.sendContinueResponse(roomId, answer);
  }

  void leave() {
    _webSocketService.leave();
  }

  void disconnect() {
    _webSocketService.disconnect();
  }
}
