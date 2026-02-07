import 'package:college_cupid/domain/models/drive_data.dart';

/// Base abstract class for storage operations
/// Can be implemented for different storage backends (Google Drive, Local Storage, etc.)
abstract class StorageRepository {
  /// Upload private data (DH key and crush list)
  Future<void> uploadPrivateData(DriveData data);

  /// Read private data
  Future<DriveData?> readPrivateData();

  /// Get list of crush emails
  Future<List<String>> getMyCrushes();

  /// Add a crush email to the list
  Future<void> addCrush(String email);

  /// Remove a crush by index
  Future<void> removeCrush(int index);

  /// Upload DH Private Key
  Future<void> uploadDHPrivateKey(String dhPrivateKey);

  /// Get DH Private Key
  Future<String?> getDHPrivateKey();

  /// Sign out / clear storage
  Future<void> signOut();

  /// Refresh access token (if applicable)
  Future<bool> refreshAccessToken();

  /// Initialize with stored credentials (if applicable)
  Future<bool> initializeWithStoredTokens();
}
