import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/domain/models/storage_type.dart';
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/repositories/storage_provider.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StorageStatusCard extends ConsumerStatefulWidget {
  const StorageStatusCard({super.key});

  @override
  ConsumerState<StorageStatusCard> createState() => _StorageStatusCardState();
}

class _StorageStatusCardState extends ConsumerState<StorageStatusCard> {
  bool _isSwitching = false;

  Future<void> _handleStorageSwitch(StorageType newType) async {
    final currentType = ref.read(storageTypeProvider);

    if (currentType == newType) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                newType == StorageType.googleDrive
                    ? Icons.cloud_upload_outlined
                    : Icons.phone_android_outlined,
                size: 48,
                color: CupidColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                newType == StorageType.googleDrive
                    ? 'Switch to Google Drive'
                    : 'Switch to Local Storage',
                style: CupidTextStyles.title1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                newType == StorageType.googleDrive
                    ? 'Your data will be migrated to Google Drive. This allows you to restore your data if you reinstall the app or switch devices.'
                    : 'Your data will be stored locally on this device only. If you uninstall the app or lose your device, your data cannot be recovered.\n\nWarning: Even if you log out, your Google Drive data will be permanently disconnected. This action cannot be undone.',
                style: CupidTextStyles.body1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancel',
                        style: CupidTextStyles.label1.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CupidColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        'Switch',
                        style: CupidTextStyles.label1.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSwitching = true);

    try {
      // If switching FROM Google Drive, ensure Drive API is initialized first
      if (currentType == StorageType.googleDrive && newType == StorageType.localStorage) {
        try {
          final onboardingController = ref.read(onboardingControllerProvider.notifier);
          await onboardingController.connectGoogleDrive();
        } catch (e) {
          debugPrint('Could not connect to Drive for reading: $e');
        }
      }

      final oldStorage = ref.read(storageRepositoryProvider);

      // Read data from current storage (if possible)
      DriveData? currentData;
      try {
        currentData = await oldStorage.readPrivateData();
      } catch (e) {
        // If reading from old storage fails (e.g., Drive API not initialized),
        // we'll just use local data
        debugPrint('Could not read from old storage: $e');
      }

      if (newType == StorageType.googleDrive) {
        // Connect to Google Drive first
        final onboardingController = ref.read(onboardingControllerProvider.notifier);
        await onboardingController.connectGoogleDrive();
      }

      // Switch storage type
      ref.read(storageTypeProvider.notifier).state = newType;

      // Get new storage repository
      final newStorage = ref.read(storageRepositoryProvider);

      // Migrate data to new storage if data exists
      if (currentData != null) {
        await newStorage.uploadPrivateData(currentData);
      } else {
        // If no data, at least upload the DH key
        final dhKey = await SharedPrefService.getDHPrivateKey();
        if (dhKey != null) {
          final data = DriveData(
            diffieHellmanPrivateKey: dhKey,
            crushEmailList: [],
          );
          await newStorage.uploadPrivateData(data);
        }
      }

      // Update user profile in backend
      final userProfile = ref.read(userProvider).myProfile;
      if (userProfile != null) {
        String? googleEmail;

        // If switching to Google Drive, get the connected account email
        if (newType == StorageType.googleDrive) {
          // The email is already stored from connectGoogleDrive
          // We just need to read it from the service
          final googleUser = FirebaseAuth.instance.currentUser;
          googleEmail = googleUser?.email;
        }

        // Ensure all required fields are present with fallbacks
        final updatedProfile = userProfile.copyWith(
          storageType: newType,
          googleAccountEmail: newType == StorageType.googleDrive ? googleEmail : null,
          hometown: userProfile.hometown.isEmpty ? 'Unknown' : userProfile.hometown,
          phnNumber: userProfile.phnNumber.isEmpty ? 'N/A' : userProfile.phnNumber,
          insta: userProfile.insta.isEmpty ? 'N/A' : userProfile.insta,
        );

        // Update backend and get the complete profile back (with isAdmin)
        final updatedProfileData =
            await ref.read(userProfileRepoProvider).updateUserProfile(updatedProfile);

        // Update local state with the profile from backend (includes isAdmin)
        if (updatedProfileData != null) {
          final completeProfile = UserProfile.fromJson(updatedProfileData);
          await ref.read(userProvider.notifier).updateMyProfile(completeProfile);
        } else {
          // Fallback to local update if backend response is null
          await ref.read(userProvider.notifier).updateMyProfile(updatedProfile);
        }
      }

      if (mounted) {
        showSnackBar(
          newType == StorageType.googleDrive
              ? 'Switched to Google Drive successfully!'
              : 'Switched to Local Storage successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar('Failed to switch storage: ${e.toString()}');
        // Revert storage type on error
        ref.read(storageTypeProvider.notifier).state = currentType;
      }
    } finally {
      if (mounted) {
        setState(() => _isSwitching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStorageType = ref.watch(storageTypeProvider);
    final userProfile = ref.watch(userProvider).myProfile;
    final isGoogleDrive = currentStorageType == StorageType.googleDrive;
    final googleEmail = userProfile?.googleAccountEmail;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isGoogleDrive
                      ? FluentIcons.cloud_checkmark_24_regular
                      : FluentIcons.phone_24_regular,
                  color: CupidColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Storage',
                        style: CupidTextStyles.label2.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isGoogleDrive ? 'Google Drive' : 'Local Storage',
                        style: CupidTextStyles.label1.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isSwitching)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isGoogleDrive
                  ? googleEmail != null
                      ? 'Connected to: $googleEmail\n\nYour data is securely stored in Google Drive and can be restored anytime.'
                      : 'Your data is securely stored in Google Drive and can be restored anytime.'
                  : 'Your data is stored locally on this device only. Switch to Google Drive for backup.',
              style: CupidTextStyles.body2.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isSwitching
                    ? null
                    : () => _handleStorageSwitch(
                          isGoogleDrive ? StorageType.localStorage : StorageType.googleDrive,
                        ),
                icon: Icon(
                  isGoogleDrive
                      ? FluentIcons.phone_24_regular
                      : FluentIcons.cloud_arrow_up_24_regular,
                  size: 20,
                ),
                label: Text(
                  isGoogleDrive ? 'Disconnect Drive' : 'Switch to Google Drive',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CupidColors.primary,
                  side: const BorderSide(color: CupidColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
