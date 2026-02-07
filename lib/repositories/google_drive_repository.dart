import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/repositories/local_storage_repository.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:college_cupid/services/firebase_drive_service.dart';
import 'package:logger/logger.dart';

/// Google Drive storage implementation with local backup
/// Always saves data locally first, then syncs to cloud
/// This ensures data is never lost even if cloud sync fails
class GoogleDriveRepository implements StorageRepository {
  static final Logger _logger = Logger();
  final LocalStorageRepository _localBackup = LocalStorageRepository();

  /// Check if error is authentication-related
  bool _isAuthError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('unauthorized') ||
        errorString.contains('401') ||
        errorString.contains('authentication') ||
        errorString.contains('token') ||
        errorString.contains('invalid_grant') ||
        errorString.contains('credentials');
  }

  @override
  Future<void> uploadPrivateData(DriveData data) async {
    // Always save to local storage first
    try {
      await _localBackup.uploadPrivateData(data);
      _logger.i('Data saved to local backup');
    } catch (e) {
      _logger.e('Failed to save to local backup: $e');
      rethrow; // Critical - local save should never fail
    }

    // Then sync to cloud (can fail without losing data)
    try {
      await FirebaseDriveService.uploadPrivateData(data);
      _logger.i('Data synced to Google Drive');
    } catch (e) {
      _logger.w('Failed to sync to Google Drive (data safe in local): $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
      // Don't rethrow - data is safe locally
    }
  }

  @override
  Future<DriveData?> readPrivateData() async {
    try {
      final driveData = await FirebaseDriveService.readPrivateData();
      if (driveData != null) {
        // Also update local backup with cloud data
        await _localBackup.uploadPrivateData(driveData);
      }
      return driveData;
    } catch (e) {
      _logger.w('Failed to read from Google Drive, trying local backup: $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
      // Fall back to local storage
      return await _localBackup.readPrivateData();
    }
  }

  @override
  Future<List<String>> getMyCrushes() async {
    try {
      final crushes = await FirebaseDriveService.getMyCrushes();
      // Update local backup
      final data = await _localBackup.readPrivateData();
      if (data != null) {
        await _localBackup.uploadPrivateData(DriveData(
          diffieHellmanPrivateKey: data.diffieHellmanPrivateKey,
          crushEmailList: crushes,
        ));
      }
      return crushes;
    } catch (e) {
      _logger.w('Failed to get crushes from Google Drive, using local: $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
      return await _localBackup.getMyCrushes();
    }
  }

  @override
  Future<void> addCrush(String email) async {
    // Add to local first
    await _localBackup.addCrush(email);

    // Then sync to cloud
    try {
      await FirebaseDriveService.addCrush(email);
    } catch (e) {
      _logger.w('Failed to add crush to Google Drive (saved locally): $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
    }
  }

  @override
  Future<void> removeCrush(int index) async {
    // Remove from local first
    await _localBackup.removeCrush(index);

    // Then sync to cloud
    try {
      await FirebaseDriveService.removeCrush(index);
    } catch (e) {
      _logger.w('Failed to remove crush from Google Drive (removed locally): $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
    }
  }

  @override
  Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    // Upload to local first
    await _localBackup.uploadDHPrivateKey(dhPrivateKey);

    // Then sync to cloud
    try {
      await FirebaseDriveService.uploadDHPrivateKey(dhPrivateKey);
    } catch (e) {
      _logger.w('Failed to upload key to Google Drive (saved locally): $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
    }
  }

  @override
  Future<String?> getDHPrivateKey() async {
    try {
      final key = await FirebaseDriveService.getDHPrivateKey();
      if (key != null) {
        // Update local backup
        await _localBackup.uploadDHPrivateKey(key);
      }
      return key;
    } catch (e) {
      _logger.w('Failed to get key from Google Drive, using local: $e');
      if (_isAuthError(e)) {
        throw AuthenticationExpiredException('Google Drive authentication expired: $e');
      }
      return await _localBackup.getDHPrivateKey();
    }
  }

  @override
  Future<void> signOut() async {
    await FirebaseDriveService.signOut();
    await _localBackup.signOut();
  }

  @override
  Future<bool> refreshAccessToken() async {
    return FirebaseDriveService.refreshAccessToken();
  }

  @override
  Future<bool> initializeWithStoredTokens() async {
    return FirebaseDriveService.initializeWithStoredTokens();
  }
}

/// Custom exception for authentication expiry
class AuthenticationExpiredException implements Exception {
  final String message;
  AuthenticationExpiredException(this.message);

  @override
  String toString() => message;
}
