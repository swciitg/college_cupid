import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:college_cupid/repositories/speed_dating.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:college_cupid/presentation/screens/speed_dating/match_revealpage.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:flutter_svg/svg.dart';
import 'package:college_cupid/functions/snackbar.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final VoidCallback onLeave;
  final String? initialMessage;
  final SpeedDatingRepository repository;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.onLeave,
    this.initialMessage,
    required this.repository,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  // final SpeedDatingRepository _repository = SpeedDatingRepository();

  final ScrollController _scrollController = ScrollController();
  bool _isChatDisabled = false;

  Timer? _timer;
  double _progress = 0.0;
  static const int _durationSeconds = 180; // 3 minutes
  int _remainingSeconds = _durationSeconds;

  // Timer related
  // For MVP, we might rely on server timeout, but let's show a visual timer if we had duration.
  // The doc says 3 minute timeout.

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      _messages.add(widget.initialMessage!);
    }
    _setupListeners();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    widget.repository.disconnect();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _progress = 1.0 - (_remainingSeconds / _durationSeconds);
          } else {
            _progress = 1.0;
            _timer?.cancel();
          }
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _setupListeners() {
    widget.repository.chatMessageStream.listen((data) {
      if (mounted) {
        HapticFeedback.lightImpact();
        setState(() {
          _messages.add("Partner: ${data['message']}");
        });
        _scrollToBottom();
      }
    });

    widget.repository.partnerLeftStream.listen((_) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        showSnackBar('Partner left the chat.');
        widget.onLeave();
      }
    });

    widget.repository.partnerDisconnectedStream.listen((_) {
      if (mounted) {
        showSnackBar('Partner disconnected. Redirecting...');
        // Redirect to speed dating screen (pop waiting page + chat)
        // Assuming we need to close everything to go back to main menu or just pop.
        // User said "redirect him to speeddating_screen".
        // Let's assume popping twice or using a named route if existed.
        // For now, assume popping back to WaitingPage which then handles its own state or just closes.
        // WaitingPage has `_disconnect`.
        HapticFeedback.heavyImpact();
        Navigator.pop(context); // Close Chat
        if (Navigator.canPop(context)) Navigator.pop(context); // Close WaitingPage if possible?
        // Or just one pop if we replaced WaitingPage.
      }
    });

    widget.repository.disconnectedStream.listen((_) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Disconnected"),
            content: const Text("Default WebSocketService: Connection Closed"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close chat
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } // Close associated waiting page if needed
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    });

    widget.repository.continuePromptStream.listen((_) {
      if (mounted) {
        HapticFeedback.heavyImpact();
        _showRevealSheet();
      }
    });

    widget.repository.partnerResponseStream.listen((data) {
      if (mounted) {
        String? partnerEmail;

        if (data != null) {
          if (data is Map<String, dynamic>) {
            partnerEmail = data['email'] as String?;
          } else if (data is String) {
            try {
              // Try decoding if it's a JSON string
              final decoded = jsonDecode(data);
              if (decoded is Map<String, dynamic>) {
                partnerEmail = decoded['email'] as String?;
              } else {
                partnerEmail = data;
              }
            } catch (e) {
              // Not a JSON string, treat as email if it looks like one, or just the data string
              partnerEmail = data;
            }
          }
        }
        HapticFeedback.heavyImpact();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MatchRevealPage(
              email: partnerEmail,
            ),
          ),
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final msg = _messageController.text.trim();
    widget.repository.sendMessage(widget.roomId, msg);
    setState(() {
      _messages.add("Me: $msg");
      _messageController.clear();
    });
    _scrollToBottom();
  }

  void _showRevealSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time’s Up!",
                        style: CupidTextStyles.title2.copyWith(color: CupidColors.greyPrimary),
                      ),
                      Text("Would you like to see who you were talking to?",
                          textAlign: TextAlign.center,
                          style: CupidTextStyles.body1.copyWith(color: CupidColors.greySecondary)),
                    ],
                  ),
                ),
                const Divider(
                  color: CupidColors.borderSecondary,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: "No",
                          onTap: () {
                            Navigator.pop(context);
                            _sendMyResponse(false);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          label: "Yes",
                          onTap: () {
                            Navigator.pop(context);
                            _sendMyResponse(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendMyResponse(bool accepted) {
    setState(() {
      _isChatDisabled = true;
    });
    widget.repository.sendMyResponse(widget.roomId, accepted ? "yes" : "no");
    showSnackBar('Response sent. Waiting for partner...');
  }

  Future<bool> _onWillPop() async {
    HapticFeedback.lightImpact();
    return (await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Are you sure?',
                    style: CupidTextStyles.title2,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Do you want to leave the chat?',
                    textAlign: TextAlign.center,
                    style: CupidTextStyles.body1,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: "No",
                          onTap: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionButton(
                          label: "Yes",
                          onTap: () {
                            widget.repository.leave();
                            widget.onLeave();
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )) ??
        false;
  }

  void _showReportConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Report User',
                style: CupidTextStyles.title2,
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you sure you want to report this user?',
                textAlign: TextAlign.center,
                style: CupidTextStyles.body1,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: "No",
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: "Yes",
                      onTap: () {
                        Navigator.of(context).pop();
                        if (LoginStore.email != null) {
                          widget.repository.reportUser(LoginStore.email!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User reported.')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                CommonWidgets.backButton(
                  context: context,
                  onTap: () async {
                    final shouldPop = await _onWillPop();
                    if (shouldPop) {
                      if (mounted) Navigator.of(context).pop();
                    }
                  },
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      const Text("Speed Dating", style: CupidTextStyles.brandTitle1),
                      const Spacer(),
                      Text(
                        _formattedTime,
                        style: CupidTextStyles.body1.copyWith(
                          color: CupidColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      PopupMenuButton<String>(
                        color: CupidColors.whitePrimary,
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (value) {
                          if (value == 'report') {
                            _showReportConfirmation();
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'report',
                              child: Text('Report',
                                  style: CupidTextStyles.body1
                                      .copyWith(color: CupidColors.blackColor)),
                            ),
                          ];
                        },
                        icon: const Icon(Icons.more_vert, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_progress < 1.0)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    tween: Tween<double>(
                      begin: 0,
                      end: _progress,
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        CupidColors.primary,
                      ),
                      minHeight: 5,
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/chatbg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isMe = msg.startsWith("Me:");
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isMe ? CupidColors.primary : CupidColors.whitePrimary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isMe ? 10 : 0),
                                topRight: const Radius.circular(10),
                                bottomLeft: const Radius.circular(10),
                                bottomRight: Radius.circular(isMe ? 0 : 10),
                              ),
                            ),
                            child: Text(msg.substring(isMe ? 4 : 9),
                                style: CupidTextStyles.label2.copyWith(
                                  color: isMe ? Colors.white : Colors.black,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          maxLines: 3,
                          minLines: 1,
                          enabled: !_isChatDisabled,
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Message',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            hintStyle:
                                CupidTextStyles.label2.copyWith(color: CupidColors.greySecondary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: CupidColors.borderSecondary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: CupidColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: CupidColors.primaryDark),
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: _isChatDisabled ? null : _sendMessage,
                        child: Container(
                            padding: const EdgeInsets.all(12),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: _isChatDisabled ? Colors.grey : const Color(0xFFEB425E),
                                borderRadius: BorderRadius.circular(14)),
                            child: SvgPicture.asset(
                              'assets/icons/send.svg',
                              width: 20,
                              height: 20,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CupidColors.borderSecondary),
        ),
        child: Text(label, style: CupidTextStyles.label1.copyWith(color: CupidColors.greyPrimary)),
      ),
    );
  }
}
