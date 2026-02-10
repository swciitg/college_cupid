import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:college_cupid/stores/login_store.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  IOWebSocketChannel? _channel;

  // Streams for various events
  final _chatMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _continuePromptController = StreamController<void>.broadcast();
  final _partnerResponseController = StreamController<dynamic>.broadcast(); // Can be map or null
  final _chatClosedController = StreamController<void>.broadcast();
  final _partnerLeftController = StreamController<void>.broadcast();
  final _partnerDisconnectedController = StreamController<void>.broadcast();
  final _matchedController = StreamController<Map<String, dynamic>>.broadcast();
  final _questionsController = StreamController<List<dynamic>>.broadcast(); // List of strings
  final _roomCreatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _disconnectedController = StreamController<void>.broadcast();
  final _poolStatsController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<void> get continuePromptStream => _continuePromptController.stream;
  Stream<dynamic> get partnerResponseStream => _partnerResponseController.stream;
  Stream<void> get chatClosedStream => _chatClosedController.stream;
  Stream<void> get partnerLeftStream => _partnerLeftController.stream;
  Stream<void> get partnerDisconnectedStream => _partnerDisconnectedController.stream;
  Stream<Map<String, dynamic>> get matchedStream => _matchedController.stream;
  Stream<List<dynamic>> get questionsStream => _questionsController.stream;
  Stream<Map<String, dynamic>> get roomCreatedStream => _roomCreatedController.stream;
  Stream<void> get disconnectedStream => _disconnectedController.stream;
  Stream<Map<String, dynamic>> get poolStatsStream => _poolStatsController.stream;

  Completer<void>? _connectionCompleter;

  Future<void> initConnection() async {
    _connectionCompleter = Completer<void>();

    try {
      log('Default WebSocketService: Connecting to wss://swc.iitg.ac.in/test/collegeCupid');
      log(LoginStore.accessToken.toString());
      _channel = IOWebSocketChannel.connect(
        Uri.parse('wss://swc.iitg.ac.in/test/collegeCupid'),
        headers: {
          'security-key': "Cupid-Dev",
          'Authorization': 'Bearer ${LoginStore.accessToken}',
        },
      );

      await _channel!.ready;

      log('Default WebSocketService: Connected to WebSocket Server');
      log("connected to websocket"); // Requested log
      _connectionCompleter!.complete();

      _setupListeners();
    } catch (e) {
      log('Default WebSocketService: Connection Error: $e');
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(e);
      }
      _disconnectedController.add(null);
    }

    return _connectionCompleter!.future;
  }

  void _setupListeners() {
    _channel!.stream.listen(
      (message) {
        log('Default WebSocketService: Received: $message');
        try {
          if (message is String) {
            final decoded = jsonDecode(message);
            if (decoded is Map<String, dynamic>) {
              // Assuming protocol: {"event": "eventName"chat, "data": ...}
              // or {"type": "eventName", "payload": ...}
              // Adjusting based on common patterns.
              // If the server sends just the event name as a key?
              // Let's assume a 'type' or 'event' field exists.

              String? eventType = decoded['event'] ?? decoded['type'];
              dynamic data = decoded['data'] ?? decoded['payload'] ?? decoded;

              if (eventType != null) {
                _handleEvent(eventType, data);
              } else {
                // If it's a map without an explicit event field,
                // maybe check keys?
                log('Default WebSocketService: Unknown message format (no event/type field)');
              }
            }
          }
        } catch (e) {
          log('Default WebSocketService: Error parsing message: $e');
        }
      },
      onDone: () {
        log('Default WebSocketService: Connection Closed');
        _disconnectedController.add(null);
      },
      onError: (error) {
        log('Default WebSocketService: Stream Error: $error');
        _disconnectedController.add(null);
      },
    );
  }

  void _handleEvent(String event, dynamic data) {
    switch (event) {
      case 'matched':
        log('Default WebSocketService: Received [matched]: $data');
        if (data != null) {
          _matchedController.add(data as Map<String, dynamic>);
        }
        break;
      case 'questions':
        log('Default WebSocketService: Received [questions]: $data');
        if (data != null && data is List) {
          _questionsController.add(data);
        }
        break;
      case 'room_created':
        log('Default WebSocketService: Received [room_created]: $data');
        if (data != null) {
          _roomCreatedController.add(data as Map<String, dynamic>);
        }
        break;
      case 'continue_prompt':
        log('Default WebSocketService: Received [continue_prompt]');
        _continuePromptController.add(null);
        break;
      case 'partner_response':
        log('Default WebSocketService: Received [partner_response]: $data');
        _partnerResponseController.add(data);
        break;
      case 'chat_message':
        log('Default WebSocketService: Received [chat_message]: $data');
        if (data != null) {
          _chatMessageController.add({'message': data});
        }
        break;

      case 'chat_closed':
        log('Default WebSocketService: Received [chat_closed]');
        _chatClosedController.add(null);
        break;
      case 'partner_left':
        log('Default WebSocketService: Received [partner_left]');
        _partnerLeftController.add(null);
        break;
      case 'partner_disconnected':
        log('Default WebSocketService: Received [partner_disconnected]');
        _partnerDisconnectedController.add(null);
        break;
      case 'pool_stats':
        log('Default WebSocketService: Received [pool_stats]: $data');
        if (data != null) {
          _poolStatsController.add(data as Map<String, dynamic>);
        }
        break;
      default:
        log('Default WebSocketService: Unhandled event: $event');
    }
  }

  void _send(String event, dynamic data) {
    if (_channel != null && _channel!.closeCode == null) {
      try {
        final message = jsonEncode({'event': event, 'data': data});
        // log('Default WebSocketService: Sending: $message');
        _channel!.sink.add(message);
      } catch (e) {
        log('Default WebSocketService: Error sending message: $e');
      }
    } else {
      log('Default WebSocketService: Cannot send, channel is null or closed');
    }
  }

  Future<void> joinPool(String email, int gender, List<String> interests, String timeJoined) async {
    if (_channel == null || _channel!.closeCode != null) {
      // simplistic check, ready checks better
      await initConnection();
    }

    log('Default WebSocketService: Emitting [join_pool] - Email: $email');
    _send('join_pool', {
      'email': email,
      'gender': gender,
      'interests': interests,
      'timejoined': timeJoined,
      'room': null,
      'chatStarted': null,
    });
  }

  void sendChatMessage(String roomId, String message) {
    log('Default WebSocketService: Emitting [chat_message] - Room: $roomId, Msg: $message');
    _send('chat_message', {
      'roomId': roomId,
      'message': message,
    });
  }

  void sendContinueResponse(String roomId, String answer) {
    log('Default WebSocketService: Emitting [continue_response]');
    _send('continue_response', {
      'roomId': roomId,
      'answer': answer,
    });
  }

  void sendMyResponse(String roomId, String answer) {
    log('Default WebSocketService: Emitting [my_response] - Room: $roomId, Answer: $answer');
    _send('my_response', {
      'roomId': roomId,
      'answer': answer,
    });
  }

  void sendReport(String email) {
    log('Default WebSocketService: Emitting [report] - Email: $email');
    _send('report', {
      'reportedEmail': email,
    });
  }

  void leave() {
    log('Default WebSocketService: Emitting [leave]');
    _send('leave', {});
  }

  void disconnect() {
    if (_channel != null && _channel!.closeCode == null) {
      try {
        _channel!.sink.close();
      } catch (e) {
        log('Default WebSocketService: Error closing channel: $e');
      }
    }
    _channel = null;
    _chatMessageController.close();
    _continuePromptController.close();
    _partnerResponseController.close();
    _chatClosedController.close();
    _partnerLeftController.close();
    _partnerDisconnectedController.close();
    _matchedController.close();
    _questionsController.close();
    _roomCreatedController.close();
    _disconnectedController.close();
    _poolStatsController.close();
  }
}
