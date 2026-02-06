import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/basic_profile_info.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';
import 'package:college_cupid/repositories/updates_repository.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/shared/endpoints.dart';

class DisplayProfileInfo extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool backButton;
  final VoidCallback? onPass;
  final VoidCallback? onSmash;
  final bool isMine;
  final bool showPass;

  const DisplayProfileInfo(
      {required this.userProfile,
      this.backButton = false,
      this.isMine = false,
      this.showPass = true,
      this.onPass,
      this.onSmash,
      super.key});

  @override
  ConsumerState<DisplayProfileInfo> createState() => _DisplayProfileInfoState();
}

class _DisplayProfileInfoState extends ConsumerState<DisplayProfileInfo> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 32;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicProfileInfo(
                  maxHeight: maxHeight,
                  width: width,
                  userProfile: widget.userProfile,
                  backButton: widget.backButton,
                  isMine: widget.isMine,
                ),
                if (widget.userProfile.surpriseQuiz.isNotEmpty)
                  _surpriseQues(widget.userProfile.surpriseQuiz.first, 0),
                if (widget.userProfile.surpriseQuiz.isEmpty) const SizedBox(height: 16),
                _image(null, width, 1),
                const SizedBox(height: 8),
                if (widget.userProfile.interests.isNotEmpty) _buildInterests(),
                if (widget.userProfile.surpriseQuiz.length < 2) const SizedBox(height: 16),
                if (widget.userProfile.surpriseQuiz.length >= 2)
                  _surpriseQues(widget.userProfile.surpriseQuiz[1], 1),
                if (widget.userProfile.images.length > 2) _image(null, width, 2),
                if (widget.userProfile.surpriseQuiz.length >= 3)
                  _surpriseQues(widget.userProfile.surpriseQuiz[2], 2),
                const SizedBox(height: 24),
                if (!widget.isMine) // Only show if not my profile
                  Row(
                    children: [
                      if (widget.showPass) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onPass,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: CupidColors.offWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FluentIcons.diamond_24_filled, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Pass",
                                    style: CupidTextStyles.label1.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onSmash,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: CupidColors.offWhiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FluentIcons.heart_24_filled, color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  "Like",
                                  style: CupidTextStyles.label1.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _surpriseQues(QuizQuestion ques, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupidColors.greyElement),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ques.question,
                        style: CupidTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: CupidColors.greySecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAnswer(ques),
                    const SizedBox(height: 8),
                    if (!widget.isMine)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReplyButton(onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReplyBottomSheet(
                                title: 'Reply to Answer',
                                onSend: (message) async {
                                  final success = await ref.read(updatesRepoProvider).replyToUser(
                                      widget.userProfile.email, message, "QUESTIONS", index);
                                  if (success) {
                                    showSnackBar("Reply sent successfully!");
                                  } else {
                                    showSnackBar("Failed to send reply");
                                  }
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswer(QuizQuestion ques) {
    // Check if there's a voice recording for this question
    final voiceRecording = widget.userProfile.voiceRecordings.firstWhere(
      (recording) => recording.question == ques.question,
      orElse: () => VoiceRecording(question: '', answer: ''),
    );

    // If there's a voice recording, show audio player
    if (voiceRecording.answer.isNotEmpty) {
      return _VoicePlayer(audioUrl: voiceRecording.answer);
    }

    // Otherwise show text answer
    return Text(
      ques.answer,
      style: CupidTextStyles.body1.copyWith(
        fontSize: 15,
      ),
    );
  }

  Widget _buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Loves",
              style: CupidTextStyles.title2.copyWith(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              ),
            )
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(_expanded ? widget.userProfile.interests.length : 4, (index) {
            final extra = widget.userProfile.interests.length - 3;
            if (!_expanded && index == 3) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = true;
                  });
                },
                child: Text(
                  "+$extra more",
                  style: CupidTextStyles.body1,
                ),
              );
            }
            return _interestChip(widget.userProfile.interests[index], index);
          }),
        ),
      ],
    );
  }

  DecoratedBox _interestChip(String label, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          label,
          style: CupidTextStyles.label2
              .copyWith(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _image(double? height, double width, int index) {
    final url = widget.userProfile.images[index].url;
    final blurHash = widget.userProfile.images[index].blurHash;
    return Stack(
      children: [
        ProfileImage(
          height: height,
          width: width,
          index: index,
          url: url,
          blurHash: blurHash,
        ),
        if (!widget.isMine)
          Positioned(
            bottom: 12,
            right: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReplyButton(onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ReplyBottomSheet(
                      title: 'Reply to Profile',
                      onSend: (message) async {
                        log("DEBUG UI: Reply button pressed for IMAGES index $index");
                        log("DEBUG UI: Sending to ${widget.userProfile.email}");
                        try {
                          final success = await ref
                              .read(updatesRepoProvider)
                              .replyToUser(widget.userProfile.email, message, "IMAGES", index);
                          log("DEBUG UI: Result success=$success");
                          if (success) {
                            showSnackBar("Reply sent successfully!");
                          } else {
                            showSnackBar("Failed to send reply");
                          }
                        } catch (e) {
                          log("DEBUG UI: Error calling repo: $e");
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}

class _VoicePlayer extends StatefulWidget {
  final String audioUrl;

  const _VoicePlayer({required this.audioUrl});

  @override
  State<_VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<_VoicePlayer> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Configure audio player for better iOS compatibility
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      try {
        // Construct the full URL - remove leading slash if present to avoid double slashes
        final audioPath =
            widget.audioUrl.startsWith('/') ? widget.audioUrl.substring(1) : widget.audioUrl;
        final fullUrl = '${Endpoints.baseUrl}/$audioPath';
        log('Playing audio from: $fullUrl');

        // Set audio context for iOS before playing
        await _audioPlayer.setAudioContext(AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.mixWithOthers},
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: false,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ));

        // Set the source first
        await _audioPlayer.setSourceUrl(fullUrl);
        // Then play
        await _audioPlayer.resume();
        setState(() => _isPlaying = true);
      } catch (e) {
        log('Error playing audio: $e');
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: CupidColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: CupidColors.primary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 60,
            child: CustomPaint(
              painter: _WaveformPainter(
                progress: _duration.inSeconds > 0 ? _position.inSeconds / _duration.inSeconds : 0.0,
                isPlaying: _isPlaying,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double progress;
  final bool isPlaying;

  _WaveformPainter({required this.progress, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    const barCount = 60;
    final barWidth = 3.0;
    final spacing = (size.width - (barCount * barWidth)) / (barCount - 1);
    final progressPosition = progress * size.width;

    for (int i = 0; i < barCount; i++) {
      final x = i * (barWidth + spacing);

      // Create more realistic varied heights using multiple sine waves
      final normalizedPosition = i / barCount;
      final wave1 = 0.4 + 0.3 * (1 - (normalizedPosition - 0.5).abs() * 2);
      final wave2 = 0.15 * (1 + (i % 5) / 5.0);
      final wave3 = 0.1 * (1 - (i % 7) / 7.0);
      final wave4 = 0.05 * (1 + (i % 3) / 3.0);

      final heightFactor = (wave1 + wave2 + wave3 + wave4).clamp(0.2, 1.0);
      final barHeight = size.height * heightFactor;
      final y = (size.height - barHeight) / 2;

      // Color based on progress
      paint.color =
          x <= progressPosition ? CupidColors.primary : CupidColors.primary.withValues(alpha: 0.3);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isPlaying != isPlaying;
  }
}
