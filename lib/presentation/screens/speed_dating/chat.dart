import 'dart:async';
import 'package:college_cupid/repositories/speed_dating.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/utils/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:college_cupid/shared/colors.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final VoidCallback onLeave;
  final String? initialMessage;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.onLeave,
    this.initialMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  final SpeedDatingRepository _repository = SpeedDatingRepository();

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
    super.dispose();
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
    _repository.chatMessageStream.listen((data) {
      if (mounted) {
        setState(() {
          _messages.add("Partner: ${data['message']}");
        });
      }
    });

    _repository.partnerLeftStream.listen((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partner left the chat.')),
        );
        widget.onLeave();
      }
    });

    _repository.partnerDisconnectedStream.listen((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Partner disconnected. Redirecting...')),
        );
        // Redirect to speed dating screen (pop waiting page + chat)
        // Assuming we need to close everything to go back to main menu or just pop.
        // User said "redirect him to speeddating_screen".
        // Let's assume popping twice or using a named route if existed.
        // For now, assume popping back to WaitingPage which then handles its own state or just closes.
        // WaitingPage has `_disconnect`.
        Navigator.pop(context); // Close Chat
        if (Navigator.canPop(context))
          Navigator.pop(context); // Close WaitingPage if possible?
        // Or just one pop if we replaced WaitingPage.
      }
    });

    _repository.disconnectedStream.listen((_) {
      if (mounted) {
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
                  if (Navigator.canPop(context))
                    Navigator.pop(
                        context); // Close associated waiting page if needed
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    });

    _repository.continuePromptStream.listen((_) {
      if (mounted) {
        _showRevealSheet();
      }
    });

    _repository.partnerResponseStream.listen((data) {
      if (mounted) {
        // If data is null, no reveal.
        if (data == null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("Refused"),
              content: const Text("No reveal this time. Try again!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(
                        context); // Close chat -> return to speed dating screen
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          );
        } else {
          // Data contains email presumably.
          // User: "display the email which i get from partner response data"
          // Assuming data is a Map or just string? Prompt says "email which i get from partner response data".
          // If data is map: data['email']? Or just data?
          // I will dump data to string to be safe.
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text("It's a Match!"),
              content:
                  Text("You both want to connect!\nPartner's Email: $data"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close chat
                  },
                  child: const Text("Great!"),
                )
              ],
            ),
          );
        }
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final msg = _messageController.text.trim();
    _repository.sendMessage(widget.roomId, msg);
    setState(() {
      _messages.add("Me: $msg");
      _messageController.clear();
    });
  }

  void _showRevealSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Time's up! Would you like to reveal your identity?",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context); // Close sheet
                        _sendMyResponse(false);
                      },
                      child: const Text("No"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        Navigator.pop(context); // Close sheet
                        _sendMyResponse(true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendMyResponse(bool accepted) {
    _repository.sendMyResponse(widget.roomId, accepted ? "yes" : "no");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Response sent. Waiting for partner...')),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to leave the chat?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _repository.leave();
                  widget.onLeave();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
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
                SizedBox(height: 20),
                CommonWidgets.backButton(context: context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text("Speed Dating", style: CupidTextStyles.brandTitle1),
                      const Spacer(),
                      Text(
                        _formattedTime,
                        style: CupidTextStyles.body1.copyWith(
                          color: CupidColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
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
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg.startsWith("Me:");
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg.substring(isMe ? 4 : 9)),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
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
