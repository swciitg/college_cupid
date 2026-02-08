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
import 'package:web_socket_channel/web_socket_channel.dart';

class WaitingPage extends StatefulWidget {
  final UserProfile userProfile;

  const WaitingPage({super.key, required this.userProfile});

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  final SpeedDatingRepository _repository = SpeedDatingRepository();
  StreamSubscription? _roomCreatedSubscription;
  StreamSubscription? _disconnectedSubscription;

  @override
  void initState() {
    super.initState();
    // _setupListeners();
    // _connectAndJoin();
    connectSocket();
  }

  void connectSocket() async {
    final wsUrl = Uri.parse('wss://swc.iitg.ac.in/test/collegeCupid');
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;
    log("message");

    // channel.stream.listen((message) {
    //   channel.sink.add('received!');
    //   channel.sink.close(status.goingAway);
    // });
  }

  void _connectAndJoin() {
    // Ensure fresh connection - maybe disconnect old one safely?
    // Repository method connect() calls initConnection() which handles state.
    _repository.connect();

    int genderInt = widget.userProfile.gender == Gender.female ? 1 : 0;

    _repository.joinPool(
      email: widget.userProfile.email,
      gender: genderInt,
      interests: widget.userProfile.interests,
    );
  }

  void _setupListeners() {
    _roomCreatedSubscription = _repository.roomCreatedStream.listen((data) {
      if (data.containsKey('roomId') && mounted) {
        // Navigate to ChatScreen
        // Providing replacement so back button from chat doesn't go to waiting
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomId: data['roomId'],
              onLeave: () {
                // ChatScreen calls this when user clicks exit or partner leaves.
                // Since we used pushReplacement, ChatScreen is on top of stack (SpeedDatingScreen is below).
                // We should pop to go back to SpeedDatingScreen.
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      }
    });

    _disconnectedSubscription = _repository.disconnectedStream.listen((_) {
      if (mounted) {
        _showErrorAndPop('Connection lost/failed. Please try again later.');
      }
    });
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
    // Also disconnecting might be good practice if we want to stop listening completely?
    // The requirement says "on pressing the cancel button or any error disconnect from websocket"
    _repository.disconnect();
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _roomCreatedSubscription?.cancel();
    _disconnectedSubscription?.cancel();
    // We do NOT disconnect here automatically because if we navigate to ChatScreen, we need the connection.
    // If we pop this page (cancel), we call _cancelAndPop which disconnects.
    // BUT if we navigate to ChatScreen, this widget is disposed (if replaced).
    // Wait, if pushReplacement is used, this widget is disposed. We must NOT disconnect in dispose if successful.
    // How to know if successful?
    // Actually, ChatScreen uses the SAME repository instance (singleton).
    // So if we just cancel subscriptions, the socket stays open.
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Finding you a partner...",
                        style: CupidTextStyles.body1,
                      ),
                      Center(
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
