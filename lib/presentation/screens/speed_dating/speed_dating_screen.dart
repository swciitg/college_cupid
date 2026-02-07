import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/repositories/speed_dating.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:flutter/material.dart';
import 'chat.dart';
import 'waiting.dart';

class SpeedDatingScreen extends StatefulWidget {
  const SpeedDatingScreen({super.key});

  @override
  State<SpeedDatingScreen> createState() => _SpeedDatingScreenState();
}

class _SpeedDatingScreenState extends State<SpeedDatingScreen> {
  final SpeedDatingRepository _repository = SpeedDatingRepository();
  bool _isWaiting = false;
  String? _currentRoomId;
  bool _isLoading = true;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _repository.connect();
    _setupListeners();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profileMap = await SharedPrefService.getMyProfile();
      if (profileMap.isNotEmpty) {
        setState(() {
          _userProfile = UserProfile.fromJson(profileMap);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        // Handle case where profile is not loaded
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
      setState(() => _isLoading = false);
    }
  }

  void _setupListeners() {
    _repository.roomCreatedStream.listen((data) {
      if (data.containsKey('roomId')) {
        setState(() {
          _currentRoomId = data['roomId'];
          _isWaiting = false;
        });
      }
    });
  }

  void _joinPool() {
    if (_userProfile == null) return;

    // Map Gender
    int genderInt = 0;
    if (_userProfile!.gender == Gender.female) {
      genderInt = 1;
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joining Speed Dating Pool...')));

    _repository.joinPool(
      email: _userProfile!.email,
      gender: genderInt,
      interests: _userProfile!.interests,
    );

    setState(() {
      _isWaiting = true;
    });
  }

  void _cancelWaiting() {
    _repository.leave();
    setState(() {
      _isWaiting = false;
    });
  }

  void _handleChatLeave() {
    // repository.leave() is called in ChatScreen exit
    setState(() {
      _currentRoomId = null;
      _isWaiting = false;
    });
  }

  @override
  void dispose() {
    // Only disconnect if we want to kill the socket on exit.
    // Usually yes for this screen.
    _repository.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentRoomId != null) {
      return ChatScreen(
        roomId: _currentRoomId!,
        onLeave: _handleChatLeave,
      );
    }

    if (_isWaiting) {
      return WaitingScreen(onCancel: _cancelWaiting);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speed Dating"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.timer, size: 100, color: Colors.pinkAccent),
            const SizedBox(height: 20),
            Text(
              "Meet new people in 3 minutes!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _joinPool,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text("Start Speed Dating"),
            ),
          ],
        ),
      ),
    );
  }
}
