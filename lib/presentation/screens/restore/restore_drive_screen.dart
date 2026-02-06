import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RestoreDriveScreen extends ConsumerStatefulWidget {
  const RestoreDriveScreen({super.key});

  @override
  ConsumerState<RestoreDriveScreen> createState() => _RestoreDriveScreenState();
}

class _RestoreDriveScreenState extends ConsumerState<RestoreDriveScreen> {
  bool _isRestoring = false;
  bool _isSkipping = false;

  Future<void> _handleRestore() async {
    setState(() => _isRestoring = true);
    try {
      final controller = ref.read(onboardingControllerProvider.notifier);

      // Connect to Google Drive
      await controller.connectGoogleDrive();

      // Try to restore data from Drive
      final restored = await controller.restoreDataFromDrive();

      if (restored && mounted) {
        // Load user profile and personal info from backend
        await controller.loadUserData();

        // Data restored successfully, navigate to home
        if (mounted) {
          context.go('/home');
        }
      } else if (mounted) {
        // No data found or failed to restore
        _showErrorDialog(
          'Restore Failed',
          'Could not find or restore your data from Google Drive. You can skip this step to start fresh.',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(
          'Connection Failed',
          'Failed to connect to Google Drive: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRestoring = false);
      }
    }
  }

  Future<void> _handleSkip() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Warning'),
        content: const Text(
          'If you skip this step:\n\n'
          '• Your previous data will be lost permanently\n'
          '• Your crush list will be cleared\n'
          '• New encryption keys will be generated\n'
          '• There is no way to recover this data later\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Skip & Start Fresh'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isSkipping = true);
      try {
        final controller = ref.read(onboardingControllerProvider.notifier);

        // Regenerate keys and clear old data
        await controller.skipRestoreAndStartFresh();

        // Load user profile and personal info from backend
        await controller.loadUserData();

        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog(
            'Error',
            'Failed to start fresh: ${e.toString()}',
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSkipping = false);
        }
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Welcome back header
              Text(
                'Welcome Back!',
                style: CupidTextStyles.brandTitle1.copyWith(
                  color: CupidColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'We found your account. Would you like to restore your previous data?',
                style: CupidTextStyles.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Google Account Warning
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important: Use the Correct Google Account',
                            style: CupidTextStyles.label1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You must connect with the same Google account you used before. Using a different account will result in generating new keys, and you won\'t be able to recover your previous data.',
                            style: CupidTextStyles.body2.copyWith(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Info card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupidColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: CupidColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: CupidColors.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Restore Your Data',
                            style: CupidTextStyles.title1.copyWith(
                              color: CupidColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By connecting your Google Drive, we can restore:',
                      style: CupidTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBulletPoint('Your crush list'),
                    _buildBulletPoint('Your encryption keys'),
                    _buildBulletPoint('Your previous matches'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.security,
                            color: CupidColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Your data is encrypted and only accessible by you.',
                              style: CupidTextStyles.body2.copyWith(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Restore button
              ElevatedButton(
                onPressed: _isRestoring || _isSkipping ? null : _handleRestore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupidColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                ),
                child: _isRestoring
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_download, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            'Connect Drive & Restore',
                            style: CupidTextStyles.label1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 16),

              // Skip button
              OutlinedButton(
                onPressed: _isRestoring || _isSkipping ? null : _handleSkip,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSkipping
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Skip & Start Fresh',
                        style: CupidTextStyles.label1.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: CupidColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: CupidTextStyles.body1.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
