import 'dart:async';
import 'dart:developer';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/screens/speed_dating/chat.dart';
import 'package:college_cupid/presentation/widgets/global/cupid_button.dart';
import 'package:college_cupid/repositories/speed_dating.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WaitingPage extends StatefulWidget {
  final UserProfile userProfile;

  const WaitingPage({super.key, required this.userProfile});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  final SpeedDatingRepository _repository = SpeedDatingRepository();

  StreamSubscription? _disconnectedSubscription;

  @override
  void initState() {
    super.initState();
    _setupListeners();
    _connectAndJoin();
    // connectSocket();
  }

  // void connectSocket() async {
  //   final wsUrl = Uri.parse('wss://swc.iitg.ac.in/test/collegeCupid');
  //   final channel = WebSocketChannel.connect(wsUrl);

  //   await channel.ready;
  //   log("message");

  //   // channel.stream.listen((message) {
  //   //   channel.sink.add('received!');
  //   //   channel.sink.close(status.goingAway);
  //   // });
  // }

  Future<void> _connectAndJoin() async {
    // Ensure fresh connection - maybe disconnect old one safely?
    // Repository method connect() calls initConnection() which handles state.
    await _repository.connect();
    log("connected to socket");

    int genderInt = widget.userProfile.gender == Gender.female ? 1 : 0;

    await _repository.joinPool(
      email: widget.userProfile.email,
      gender: genderInt,
      interests: widget.userProfile.interests,
    );
  }

  bool _isMatched = false;
  String? _roomId;
  List<String>? _questions;
  StreamSubscription? _matchedSubscription;
  StreamSubscription? _questionsSubscription;
  StreamSubscription? _chatMessageSubscription;

  void _setupListeners() {
    _matchedSubscription = _repository.matchedStream.listen((data) {
      if (mounted) {
        setState(() {
          _isMatched = true;
          _roomId = data['roomId'];
        });
      }
    });

    _questionsSubscription = _repository.questionsStream.listen((data) {
      if (mounted && _roomId != null) {
        // Show questions to pick
        setState(() {
          _questions = List<String>.from(data);
        });
        _showQuestionPicker();
      }
    });

    // If we are the one waiting (didn't get questions), we wait for the first message to enter chat
    _chatMessageSubscription = _repository.chatMessageStream.listen((data) {
      if (mounted && _isMatched && _roomId != null) {
        _navigateToChat(_roomId!,
            initialMessage: "Partner: ${data['message']}");
      }
    });

    _disconnectedSubscription = _repository.disconnectedStream.listen((_) {
      if (mounted) {
        _showErrorAndPop('Connection lost/failed. Please try again later.');
      }
    });
  }

  void _showQuestionPicker() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent closing without selection
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pick a conversation starter",
                    style: CupidTextStyles.brandTitle2),
                const SizedBox(height: 16),
                if (_questions != null)
                  ..._questions!.map((q) => ListTile(
                        title: Text(q),
                        onTap: () {
                          Navigator.pop(context); // Close sheet
                          _sendStarterAndChat(q);
                        },
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendStarterAndChat(String question) {
    if (_roomId != null) {
      _repository.sendMessage(_roomId!, question);
      _navigateToChat(_roomId!, initialMessage: "Me: $question");
    }
  }

  void _navigateToChat(String roomId, {String? initialMessage}) {
    // Avoid double navigation
    // We can just pushReplacement
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          roomId: roomId,
          initialMessage: initialMessage,
          onLeave: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          repository: _repository,
        ),
      ),
    );
  }

  void _showErrorAndPop(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    _cancelAndPop();
  }

  void _cancelAndPop() {
    _repository.leave();
    _repository.disconnect();
    context.pop();
  }

  @override
  void dispose() {
    _matchedSubscription?.cancel();
    _questionsSubscription?.cancel();
    _chatMessageSubscription?.cancel();
    _disconnectedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupidColors.surfaceS0,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Back button acts as Cancel too? Probably safer to force use of Cancel button or handle WillPopScope.
                  // But for UI consistency, let's keep it.
                  GestureDetector(
                    onTap: _cancelAndPop,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back,
                          size: 18, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("Speed Dating",
                      style: CupidTextStyles.brandTitle1),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isMatched
                            ? "Matched! Waiting for partner..."
                            : "Finding you a partner...",
                        style: CupidTextStyles.body1,
                      ),
                      const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: CupidColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: CupidColors.borderSecondary,
            ),
            Expanded(
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFFFE6E6),
                    shape: OvalBorder(),
                  ),
                  child: Center(
                      child: Image.asset("assets/images/female_doll.png")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CupidButton(
                text: 'Cancel',
                onTap: _cancelAndPop,
                backgroundColor: CupidColors.primaryLight,
                style: CupidTextStyles.label1.copyWith(
                  color: CupidColors
                      .primary, // Contrast color for primaryLight? Assuming primaryLight is light pink, so primary (red) text is good.
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
