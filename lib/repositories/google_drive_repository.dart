import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:college_cupid/services/firebase_drive_service.dart';

/// Google Drive storage implementation
/// Provides cloud storage using Google Drive API
class GoogleDriveRepository implements StorageRepository {
  @override
  Future<void> uploadPrivateData(DriveData data) async {
    return FirebaseDriveService.uploadPrivateData(data);
  }

  @override
  Future<DriveData?> readPrivateData() async {
    return FirebaseDriveService.readPrivateData();
  }

  @override
  Future<List<String>> getMyCrushes() async {
    return FirebaseDriveService.getMyCrushes();
  }

  @override
  Future<void> addCrush(String email) async {
    return FirebaseDriveService.addCrush(email);
  }

  @override
  Future<void> removeCrush(int index) async {
    return FirebaseDriveService.removeCrush(index);
  }

  @override
  Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    return FirebaseDriveService.uploadDHPrivateKey(dhPrivateKey);
  }

  @override
  Future<String?> getDHPrivateKey() async {
    return FirebaseDriveService.getDHPrivateKey();
  }

  @override
  Future<void> signOut() async {
    return FirebaseDriveService.signOut();
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
