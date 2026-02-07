import 'dart:convert';
import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

/// Local storage implementation using Secure Storage
/// Data is stored encrypted on the device
class LocalStorageRepository implements StorageRepository {
  static final Logger _logger = Logger();
  static const String _privateDataKey = 'local_private_data';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  Future<void> uploadPrivateData(DriveData data) async {
    try {
      final jsonString = jsonEncode(data.toJSON());
      await _secureStorage.write(key: _privateDataKey, value: jsonString);
      _logger.i('Private data saved to local storage');
    } catch (e) {
      _logger.e('Error uploading private data to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<DriveData?> readPrivateData() async {
    try {
      final jsonString = await _secureStorage.read(key: _privateDataKey);
      if (jsonString == null || jsonString.isEmpty) {
        _logger.i('No private data found in local storage');
        return null;
      }

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return DriveData.fromJSON(jsonData);
    } catch (e) {
      _logger.e('Error reading private data from local storage: $e');
      return null;
    }
  }

  @override
  Future<List<String>> getMyCrushes() async {
    try {
      final data = await readPrivateData();
      return data?.crushEmailList ?? [];
    } catch (e) {
      _logger.e('Error getting crushes from local storage: $e');
      return [];
    }
  }

  @override
  Future<void> addCrush(String email) async {
    try {
      final data = await readPrivateData();
      if (data == null) {
        // Create new data with the crush
        final newData = DriveData(
          diffieHellmanPrivateKey: '',
          crushEmailList: [email],
        );
        await uploadPrivateData(newData);
      } else {
        // Add to existing crushes
        if (!data.crushEmailList.contains(email)) {
          final updatedData = DriveData(
            diffieHellmanPrivateKey: data.diffieHellmanPrivateKey,
            crushEmailList: [...data.crushEmailList, email],
          );
          await uploadPrivateData(updatedData);
        }
      }
      _logger.i('Crush added to local storage: $email');
    } catch (e) {
      _logger.e('Error adding crush to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> removeCrush(int index) async {
    try {
      final data = await readPrivateData();
      if (data != null && index >= 0 && index < data.crushEmailList.length) {
        final updatedList = List<String>.from(data.crushEmailList);
        updatedList.removeAt(index);

        final updatedData = DriveData(
          diffieHellmanPrivateKey: data.diffieHellmanPrivateKey,
          crushEmailList: updatedList,
        );
        await uploadPrivateData(updatedData);
        _logger.i('Crush removed from local storage at index: $index');
      }
    } catch (e) {
      _logger.e('Error removing crush from local storage: $e');
      rethrow;
    }
  }

  @override
  Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    try {
      final existingData = await readPrivateData();
      final updatedData = DriveData(
        diffieHellmanPrivateKey: dhPrivateKey,
        crushEmailList: existingData?.crushEmailList ?? [],
      );
      await uploadPrivateData(updatedData);
      _logger.i('DH private key uploaded to local storage');
    } catch (e) {
      _logger.e('Error uploading DH private key to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getDHPrivateKey() async {
    try {
      final data = await readPrivateData();
      return data?.diffieHellmanPrivateKey;
    } catch (e) {
      _logger.e('Error getting DH private key from local storage: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _secureStorage.delete(key: _privateDataKey);
      _logger.i('Local storage cleared');
    } catch (e) {
      _logger.e('Error clearing local storage: $e');
      rethrow;
    }
  }

  @override
  Future<bool> refreshAccessToken() async {
    // No-op for local storage, always return true
    return true;
  }

  @override
  Future<bool> initializeWithStoredTokens() async {
    // No-op for local storage, always return true
    return true;
  }
}
