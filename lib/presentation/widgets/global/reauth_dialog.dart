import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dialog shown when Google Drive authentication has expired
/// Prompts user to re-authenticate with their Google account
class ReAuthDialog extends ConsumerStatefulWidget {
  final String? googleAccountEmail;
  final VoidCallback? onSuccess;

  const ReAuthDialog({
    this.googleAccountEmail,
    this.onSuccess,
    super.key,
  });

  @override
  ConsumerState<ReAuthDialog> createState() => _ReAuthDialogState();
}

class _ReAuthDialogState extends ConsumerState<ReAuthDialog> {
  bool _isReAuthenticating = false;
  String? _errorMessage;

  Future<void> _handleReAuth() async {
    setState(() {
      _isReAuthenticating = true;
      _errorMessage = null;
    });

    try {
      final controller = ref.read(onboardingControllerProvider.notifier);

      // Re-authenticate with Google Drive
      await controller.connectGoogleDrive(loginHint: widget.googleAccountEmail);

      if (mounted) {
        // Success - close dialog and trigger callback
        Navigator.of(context).pop(true);
        widget.onSuccess?.call();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isReAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.orange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Reconnect Required',
              style: CupidTextStyles.title1.copyWith(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Google Drive connection has expired. Please reconnect to sync your data.',
              style: CupidTextStyles.body1,
            ),
            const SizedBox(height: 16),
            if (widget.googleAccountEmail != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupidColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: CupidColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: CupidColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reconnect with:',
                            style: CupidTextStyles.label2.copyWith(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            widget.googleAccountEmail!,
                            style: CupidTextStyles.label1.copyWith(
                              fontSize: 13,
                              color: CupidColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Don\'t worry! Your data is safe in local storage. Reconnecting will sync your latest data to the cloud.',
                      style: CupidTextStyles.body2.copyWith(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: CupidTextStyles.body2.copyWith(
                          fontSize: 12,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isReAuthenticating ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Later',
            style: CupidTextStyles.label1.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isReAuthenticating ? null : _handleReAuth,
          style: ElevatedButton.styleFrom(
            backgroundColor: CupidColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isReAuthenticating
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_upload, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Reconnect',
                      style: CupidTextStyles.label1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
