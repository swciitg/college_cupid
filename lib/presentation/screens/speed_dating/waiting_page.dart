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
import 'package:college_cupid/presentation/widgets/global/ripple_animation.dart';
import 'package:college_cupid/functions/snackbar.dart';

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
  }

  Future<void> _connectAndJoin() async {
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
  final TextEditingController _customMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  StreamSubscription? _matchedSubscription;
  StreamSubscription? _questionsSubscription;
  StreamSubscription? _chatMessageSubscription;
  StreamSubscription? _poolStatsSubscription;
  int _boysCount = 0;
  int _girlsCount = 0;
  int _totalRooms = 0;

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
      }
    });

    // If we are the one waiting (didn't get questions), we wait for the first message to enter chat
    _chatMessageSubscription = _repository.chatMessageStream.listen((data) {
      if (mounted && _isMatched && _roomId != null) {
        _navigateToChat(_roomId!, initialMessage: "Partner: ${data['message']}");
      }
    });

    _disconnectedSubscription = _repository.disconnectedStream.listen((_) {
      if (mounted) {
        _showErrorAndPop(null);
      }
    });

    _poolStatsSubscription = _repository.poolStatsStream.listen((data) {
      if (mounted) {
        setState(() {
          _boysCount = data['boysCount'] ?? 0;
          _girlsCount = data['girlsCount'] ?? 0;
          _totalRooms = data['totalRooms'] ?? 0;
        });
      }
    });
  }

  void _sendStarterAndChat(String question) {
    if (_roomId != null) {
      _repository.sendMessage(_roomId!, question);
      _navigateToChat(_roomId!, initialMessage: "Me: $question");
    }
  }

  void _navigateToChat(String roomId, {String? initialMessage}) {
    // Cancel subscriptions before navigating to prevent double handling
    _matchedSubscription?.cancel();
    _questionsSubscription?.cancel();
    _chatMessageSubscription?.cancel();
    _poolStatsSubscription?.cancel();

    // Navigate to chat, passing the repository so chat can handle it
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

  void _showErrorAndPop(String? message) {
    if (message != null) {
      showSnackBar(message);
    }
    _cancelAndPop();
  }

  void _cancelAndPop() {
    try {
      _repository.leave();
    } catch (e) {
      // Ignore errors when leaving (connection might be already closed)
      log('Error sending leave event: $e');
    }
    _repository.disconnect();
    context.pop();
  }

  @override
  void dispose() {
    _matchedSubscription?.cancel();
    _questionsSubscription?.cancel();
    _chatMessageSubscription?.cancel();
    _disconnectedSubscription?.cancel();
    _poolStatsSubscription?.cancel();
    _customMessageController.dispose();
    _scrollController.dispose();

    // Clean up repository connection
    try {
      _repository.leave();
    } catch (e) {
      log('Error sending leave event in dispose: $e');
    }
    _repository.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const avatarSize = 250.0;

    return Scaffold(
      backgroundColor: CupidColors.surfaceS0,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Header & Background Elements
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
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
                        child: const Icon(Icons.arrow_back, size: 18, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Speed Dating", style: CupidTextStyles.brandTitle1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isMatched ? "Found Someone" : "Finding you a partner...",
                          style: CupidTextStyles.body1.copyWith(
                            color: _isMatched ? CupidColors.green : CupidColors.greySecondary,
                          ),
                        ),
                        if (!_isMatched)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: CupidColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. Stats Card
            Positioned(
              top: 140,
              left: 20,
              right: 20,
              child: widget.userProfile.isAdmin
                  ? Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_boysCount',
                                style: CupidTextStyles.brandTitle2.copyWith(
                                  color: CupidColors.blackColor,
                                ),
                              ),
                              Text(
                                'Boys',
                                style: CupidTextStyles.label2.copyWith(
                                  color: CupidColors.greySecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: CupidColors.greyTertiary,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_girlsCount',
                                style: CupidTextStyles.brandTitle2.copyWith(
                                  color: CupidColors.primary,
                                ),
                              ),
                              Text(
                                'Girls',
                                style: CupidTextStyles.label2.copyWith(
                                  color: CupidColors.greySecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: CupidColors.greyTertiary,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$_totalRooms',
                                style: CupidTextStyles.brandTitle2.copyWith(
                                  color: CupidColors.primary,
                                ),
                              ),
                              Text(
                                'Rooms',
                                style: CupidTextStyles.label2.copyWith(
                                  color: CupidColors.greySecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Text(
                      "${_boysCount + _girlsCount} active users",
                      style: CupidTextStyles.body1.copyWith(
                        color: _isMatched ? CupidColors.green : CupidColors.greySecondary,
                      ),
                    ),
            ),

            // 3. Avatar Animation Layer
            Positioned.fill(
              top: 220,
              bottom: _isMatched ? 300 : 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Partner Avatar (Comes from behind/right)
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutBack,
                    alignment: _isMatched ? const Alignment(0.6, -0.2) : Alignment.center,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _isMatched ? 1.0 : 0.0,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOutBack,
                        scale: _isMatched ? 0.65 : 0.5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: avatarSize,
                              height: avatarSize,
                              decoration: ShapeDecoration(
                                color: Color(widget.userProfile.gender != Gender.female
                                    ? 0xFFFFE6E6
                                    : 0xFF5F0A18),
                                shape: const OvalBorder(),
                              ),
                              child: Center(
                                child: Image.asset(
                                  widget.userProfile.gender == Gender.female
                                      ? "assets/images/male_doll.png"
                                      : "assets/images/female_doll.png",
                                  scale: 0.75,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("Who?", style: CupidTextStyles.brandTitle2),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // User Avatar (Moves Left)
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutBack,
                    alignment: _isMatched ? const Alignment(-0.6, -0.2) : Alignment.center,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOutBack,
                      scale: _isMatched ? 0.65 : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isMatched
                              ? Container(
                                  width: avatarSize,
                                  height: avatarSize,
                                  decoration: ShapeDecoration(
                                    color: Color(widget.userProfile.gender == Gender.female
                                        ? 0xFFFFE6E6
                                        : 0xFF5F0A18),
                                    shape: const OvalBorder(),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      widget.userProfile.gender == Gender.female
                                          ? "assets/images/female_doll.png"
                                          : "assets/images/male_doll.png",
                                      scale: 0.75,
                                    ),
                                  ),
                                )
                              : RippleAnimation(
                                  color: widget.userProfile.gender == Gender.female
                                      ? const Color(0xFFFFE6E6)
                                      : const Color(0xFF5F0A18),
                                  child: Container(
                                    width: avatarSize,
                                    height: avatarSize,
                                    decoration: ShapeDecoration(
                                      color: Color(widget.userProfile.gender == Gender.female
                                          ? 0xFFFFE6E6
                                          : 0xFF5F0A18),
                                      shape: const OvalBorder(),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        widget.userProfile.gender != Gender.female
                                            ? "assets/images/male_doll.png"
                                            : "assets/images/female_doll.png",
                                        scale: 0.75,
                                      ),
                                    ),
                                  ),
                                ),
                          if (_isMatched) ...[
                            const SizedBox(height: 10),
                            const Text("You", style: CupidTextStyles.brandTitle2),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Bottom UI Layer
            if (!_isMatched)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: CupidButton(
                  text: 'Cancel',
                  onTap: _cancelAndPop,
                  backgroundColor: CupidColors.primaryLight,
                  style: CupidTextStyles.label1.copyWith(
                    color: CupidColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            // Question Picker
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              bottom: (_isMatched && _questions != null) ? 0 : -500,
              left: 0,
              right: 0,
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select a prompt and start chatting",
                          style: CupidTextStyles.body1),
                      const SizedBox(height: 12),
                      if (_questions != null)
                        ..._questions!.map((q) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: () => _sendStarterAndChat(q),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: CupidColors.surfaceS2,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: CupidColors.borderSecondary),
                                  ),
                                  child: Text(q,
                                      style: CupidTextStyles.body2.copyWith(color: Colors.black)),
                                ),
                              ),
                            )),
                      const SizedBox(height: 12),
                      const Center(child: Text("OR", style: CupidTextStyles.label2)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _customMessageController,
                              decoration: InputDecoration(
                                hintText: "Type your own...",
                                filled: true,
                                fillColor: CupidColors.surfaceS2,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              if (_customMessageController.text.trim().isNotEmpty) {
                                _sendStarterAndChat(_customMessageController.text.trim());
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: CupidColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send, color: Colors.white, size: 20),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                    ],
                  ),
                ),
              ),
            ),

            // Waiting for partner text
            if (_isMatched && _questions == null)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: CupidColors.primary),
                      const SizedBox(height: 16),
                      Text("Waiting for partner to initiate...",
                          style: CupidTextStyles.body1.copyWith(color: CupidColors.greySecondary)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
