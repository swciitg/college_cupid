import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/database_strings.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:college_cupid/stores/login_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VoicePlayer extends StatefulWidget {
  final String audioUrl;

  const VoicePlayer({required this.audioUrl, super.key});

  @override
  State<VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<VoicePlayer> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _localFilePath;

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

  Future<void> _downloadAndCacheAudio() async {
    if (_localFilePath != null) return; // Already downloaded

    setState(() => _isLoading = true);

    try {
      final audioPath =
          widget.audioUrl.startsWith('/') ? widget.audioUrl.substring(1) : widget.audioUrl;
      final fullUrl = '${Endpoints.baseUrl}/$audioPath';

      log('Downloading audio from: $fullUrl');

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = widget.audioUrl.split('/').last;
      final filePath = '${tempDir.path}/$fileName';

      // Check if already exists
      final file = File(filePath);
      if (await file.exists()) {
        log('Audio file already cached at: $filePath');
        setState(() {
          _localFilePath = filePath;
          _isLoading = false;
        });
        return;
      }

      // Download the file
      final dio = Dio();

      // Add authentication headers
      final options = Options(
        headers: {
          DatabaseStrings.authorization: 'Bearer ${LoginStore.accessToken}',
          'Security-Key': Endpoints.apiSecurityKey,
        },
      );

      await dio.download(fullUrl, filePath, options: options);

      log('Audio downloaded successfully to: $filePath');
      setState(() {
        _localFilePath = filePath;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      log('Error downloading audio: $e');
      log('Stack trace: $stackTrace');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      try {
        // Download audio if not already cached
        if (_localFilePath == null) {
          await _downloadAndCacheAudio();
        }

        if (_localFilePath == null) {
          log('Failed to download audio file');
          return;
        }

        log('Playing audio from local file: $_localFilePath');

        // Set audio context before playing
        await _audioPlayer.setAudioContext(AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.mixWithOthers},
          ),
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ));

        // Play from local file
        await _audioPlayer.play(DeviceFileSource(_localFilePath!));
        log('Audio player started successfully');
        setState(() => _isPlaying = true);
      } catch (e, stackTrace) {
        log('Error playing audio: $e');
        log('Stack trace: $stackTrace');
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
          onTap: _isLoading ? null : _togglePlay,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: CupidColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
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
    const barWidth = 3.0;
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
