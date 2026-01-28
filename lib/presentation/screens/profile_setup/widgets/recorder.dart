import 'package:audioplayers/audioplayers.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

class AudioRecorder extends StatefulWidget {
  final Function(String path) onRecordingComplete;
  final Function(String answer) onChanged;

  final VoidCallback onDelete;
  final String? existingFilePath;
  final TextEditingController textController;
  // final VoidCallback onChanged;

  const AudioRecorder({
    super.key,
    required this.onRecordingComplete,
    required this.onDelete,
    this.existingFilePath,
    required this.textController, required this.onChanged,
  });

  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final _waveController = WaveformRecorderController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isRecording = false; 
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingFilePath?.isNotEmpty == true) {
      _recordedFilePath = widget.existingFilePath;
    }

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasRecording =
        _recordedFilePath != null && _recordedFilePath!.isNotEmpty;

      return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: _isRecording || hasRecording ? 60 : 100, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (_isRecording || hasRecording) 
              ? CupidColors.brandPurple600 
              : Colors.transparent // Hide border when showing TextField
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _buildCurrentState(hasRecording),
      ),
    );
  }
  Widget _buildCurrentState(bool hasRecording) {
    if (hasRecording) {
      return _buildPlayerView();
    } else if (_isRecording) {
      return _buildWaveformView();
    } else {
      return _buildIdleView();
    }
  }

  /// 1. IDLE STATE: TextField + Mic Button
  Widget _buildIdleView() {
    return Stack(
      key: const ValueKey('idle'),
      children: [
        CustomTextField(
          label: "",
          hintText: "Write your answer here...",
          controller: widget.textController,
          maxLines: 3,
          textStyle: CupidStyles.subHeadingTextStyle.copyWith(
            color: CupidColors.grey700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          onChanged: widget.onChanged,
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: _startRecording,
            child: voiceButton(),
          ),
        ),
      ],
    );
  }

  /// 2. RECORDING STATE: Waveform + Stop Button
  Widget _buildWaveformView() {
    return Padding(
      key: const ValueKey('recording'),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: WaveformRecorder(
                controller: _waveController,
                height: 50,
                onRecordingStopped: _onRecordingStopped,
              ),
            ),
          ),
          GestureDetector(
            onTap: _stopRecording,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stop, color: Colors.red, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. RECORDED STATE: Player + Delete Button
  Widget _buildPlayerView() {
    return Padding(
      key: const ValueKey('player'),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: CupidColors.brandPurple600,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _recordedFilePath!.split('/').last,
              style: CupidStyles.normalTextStyle.copyWith(
                color: CupidColors.grey600,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: _deleteRecording,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }

  /// ------------------ ACTIONS ------------------

  Future<void> _startRecording() async {
    try {
      // Clear any previous text/focus if needed
      FocusManager.instance.primaryFocus?.unfocus();
      
      setState(() {
        _isRecording = true;
      });
      // Small delay to allow UI to build WaveformRecorder before starting
      await Future.delayed(const Duration(milliseconds: 100));
      await _waveController.startRecording();
    } catch (e) {
      debugPrint("Error starting recorder: $e");
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _waveController.stopRecording(); 
      // Note: onRecordingStopped callback will handle the state update
    } catch (e) {
      debugPrint("Error stopping recorder: $e");
    }
  }

  Future<void> _onRecordingStopped() async {
    final file = _waveController.file;
    if (file == null) {
        setState(() => _isRecording = false);
        return;
    }

    setState(() {
      _isRecording = false;
      _recordedFilePath = file.path;
    });

    widget.onRecordingComplete(file.path);
  }

  Future<void> _togglePlay() async {
    if (_recordedFilePath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() => _isPlaying = true);
    }
  }

  Future<void> _deleteRecording() async {
    await _audioPlayer.stop();

    setState(() {
      _recordedFilePath = null;
      _isPlaying = false;
      _isRecording = false;
    });

    widget.onDelete();
  }
}


Widget voiceButton() {

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 6.0,
          offset: Offset(0, 4),
          spreadRadius: 1.0,
        )
      ],
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 4,
      children: [
        Text(
          'Voice',
          style: TextStyle(
            color: Color(0xFF5B616D),
            fontSize: 12,
            fontFamily: 'Open Sauce Two',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        Icon(
          Icons.mic,
          size: 16,
        )
      ],
    ),
  );
}

