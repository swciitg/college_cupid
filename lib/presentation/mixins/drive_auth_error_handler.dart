import 'package:college_cupid/presentation/widgets/global/reauth_dialog.dart';
import 'package:college_cupid/repositories/google_drive_repository.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin to handle Google Drive authentication errors
/// Automatically shows re-authentication dialog when auth expires
mixin DriveAuthErrorHandler<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// Wrap any Drive operation with automatic error handling
  Future<R?> handleDriveOperation<R>(
    Future<R> Function() operation, {
    bool showReAuthDialog = true,
    VoidCallback? onReAuthSuccess,
  }) async {
    try {
      return await operation();
    } on AuthenticationExpiredException catch (e) {
      debugPrint('Drive authentication expired: $e');

      if (showReAuthDialog && mounted) {
        final userProfile = ref.read(userProvider).myProfile;
        final googleEmail = userProfile?.googleAccountEmail;

        final shouldReAuth = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => ReAuthDialog(
            googleAccountEmail: googleEmail,
            onSuccess: onReAuthSuccess,
          ),
        );

        if (shouldReAuth == true) {
          // Retry the operation after successful re-auth
          try {
            return await operation();
          } catch (retryError) {
            debugPrint('Operation failed after re-auth: $retryError');
            return null;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Drive operation error: $e');
      rethrow;
    }
  }

  /// Show re-auth dialog manually
  Future<bool?> showReAuthDialog({VoidCallback? onSuccess}) async {
    if (!mounted) return false;

    final userProfile = ref.read(userProvider).myProfile;
    final googleEmail = userProfile?.googleAccountEmail;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReAuthDialog(
        googleAccountEmail: googleEmail,
        onSuccess: onSuccess,
      ),
    );
  }
}
