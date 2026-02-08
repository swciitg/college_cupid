import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'dart:async';

class WebSocketService {
  late io.Socket _socket;

  // Streams for various events
  final _chatMessageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _continueResponseController = StreamController<String>.broadcast();
  final _chatClosedController = StreamController<void>.broadcast();
  final _partnerLeftController = StreamController<void>.broadcast();
  final _partnerDisconnectedController = StreamController<void>.broadcast();
  final _roomCreatedController =
      StreamController<Map<String, dynamic>>.broadcast();

  final _disconnectedController = StreamController<void>.broadcast();

  Stream<Map<String, dynamic>> get chatMessageStream =>
      _chatMessageController.stream;
  Stream<String> get continueResponseStream =>
      _continueResponseController.stream;
  Stream<void> get chatClosedStream => _chatClosedController.stream;
  Stream<void> get partnerLeftStream => _partnerLeftController.stream;
  Stream<void> get partnerDisconnectedStream =>
      _partnerDisconnectedController.stream;
  Stream<Map<String, dynamic>> get roomCreatedStream =>
      _roomCreatedController.stream;
  Stream<void> get disconnectedStream => _disconnectedController.stream;

  void initConnection() {
    _socket = io.io(
      'https://swc.iitg.ac.in',
      io.OptionBuilder()
          .setPath('/test/collegeCupid')
          .setTransports(['polling', 'websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      log('Default WebSocketService: Connected to WebSocket Server');
    });

    _socket.onDisconnect((_) {
      log('Default WebSocketService: Disconnected from WebSocket Server');
      _disconnectedController.add(null);
    });

    _socket.onConnectError((data) {
      log('Default WebSocketService: Connect Error: $data');
      _disconnectedController.add(null);
    });

    _socket.onError((data) {
      log('Default WebSocketService: Error: $data');
    });

    _setupListeners();
  }

  void _setupListeners() {
    _socket.on('room_created', (data) {
      log('Default WebSocketService: Received [room_created]: $data');
      if (data != null) {
        _roomCreatedController.add(data as Map<String, dynamic>);
      }
    });

    _socket.on('chat_message', (data) {
      log('Default WebSocketService: Received [chat_message]: $data');
      if (data != null) {
        // Expected payload is just the string message, but let's wrap it for consistency if needed
        // The doc says payload is "string"
        _chatMessageController.add({'message': data});
      }
    });

    _socket.on('continue_response', (data) {
      log('Default WebSocketService: Received [continue_response]: $data');
      if (data != null) {
        _continueResponseController.add(data as String);
      }
    });

    _socket.on('chat_closed', (_) {
      log('Default WebSocketService: Received [chat_closed]');
      _chatClosedController.add(null);
    });

    _socket.on('partner_left', (_) {
      log('Default WebSocketService: Received [partner_left]');
      _partnerLeftController.add(null);
    });

    _socket.on('partner_disconnected', (_) {
      log('Default WebSocketService: Received [partner_disconnected]');
      _partnerDisconnectedController.add(null);
    });
  }

  void joinPool(
      String email, int gender, List<String> interests, String timeJoined) {
    log('Default WebSocketService: Emitting [join_pool] - Email: $email, Gender: $gender');
    _socket.emit('join_pool', {
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
    _socket.emit('chat_message', {
      'roomId': roomId,
      'message': message,
    });
  }

  void sendContinueResponse(String roomId, String answer) {
    log('Default WebSocketService: Emitting [continue_response] - Room: $roomId, Answer: $answer');
    _socket.emit('continue_response', {
      'roomId': roomId,
      'answer': answer,
    });
  }

  void leave() {
    log('Default WebSocketService: Emitting [leave]');
    _socket.emit('leave');
  }

  void disconnect() {
    _socket.disconnect();
    _chatMessageController.close();
    _continueResponseController.close();
    _chatClosedController.close();
    _partnerLeftController.close();
    _partnerDisconnectedController.close();
    _roomCreatedController.close();
    _disconnectedController.close();
  }
}
