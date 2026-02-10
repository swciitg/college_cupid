import 'dart:developer';

import 'package:college_cupid/services/websocket_service.dart';

class SpeedDatingRepository {
  final WebSocketService _webSocketService = WebSocketService();

  SpeedDatingRepository();

  Stream<Map<String, dynamic>> get chatMessageStream => _webSocketService.chatMessageStream;
  Stream<void> get continuePromptStream => _webSocketService.continuePromptStream;
  Stream<dynamic> get partnerResponseStream => _webSocketService.partnerResponseStream;
  Stream<void> get chatClosedStream => _webSocketService.chatClosedStream;
  Stream<void> get partnerLeftStream => _webSocketService.partnerLeftStream;
  Stream<void> get partnerDisconnectedStream => _webSocketService.partnerDisconnectedStream;
  Stream<Map<String, dynamic>> get roomCreatedStream => _webSocketService.roomCreatedStream;
  Stream<Map<String, dynamic>> get matchedStream => _webSocketService.matchedStream;
  Stream<List<dynamic>> get questionsStream => _webSocketService.questionsStream;
  Stream<void> get disconnectedStream => _webSocketService.disconnectedStream;
  Stream<Map<String, dynamic>> get poolStatsStream => _webSocketService.poolStatsStream;

  Future<void> connect() async {
    log('SpeedDatingRepository: Initiating WebSocket connection');
    await _webSocketService.initConnection();
  }

  Future<void> joinPool({
    required String email,
    required int gender,
    required List<String> interests,
  }) async {
    await _webSocketService.joinPool(
      email,
      gender,
      interests,
      DateTime.now().toIso8601String(),
    );
  }

  void sendMessage(String roomId, String message) {
    _webSocketService.sendChatMessage(roomId, message);
  }

  void sendMyResponse(String roomId, String answer) {
    _webSocketService.sendMyResponse(roomId, answer);
  }

  void reportUser(String email) {
    _webSocketService.sendReport(email);
  }

  void leave() {
    _webSocketService.leave();
  }

  void disconnect() {
    try {
      leave();
    } catch (e) {
      log("Error sending leave event", name: "SpeedDatingRepository");
    }
    _webSocketService.disconnect();
  }
}
