import 'dart:convert';
import 'dart:developer' as math;
import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage implementation using Secure Storage
/// Data is stored encrypted on the device
class LocalStorageRepository implements StorageRepository {
  static const String _privateDataKey = 'local_private_data';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  void log(String message) {
    math.log(message, name: 'LocalStorageRepository');
  }

  @override
  Future<void> uploadPrivateData(DriveData data) async {
    try {
      final jsonString = jsonEncode(data.toJSON());
      await _secureStorage.write(key: _privateDataKey, value: jsonString);
      log('Private data saved to local storage');
    } catch (e) {
      log('Error uploading private data to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<DriveData?> readPrivateData() async {
    try {
      final jsonString = await _secureStorage.read(key: _privateDataKey);
      if (jsonString == null || jsonString.isEmpty) {
        log('No private data found in local storage');
        return null;
      }

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      return DriveData.fromJSON(jsonData);
    } catch (e) {
      log('Error reading private data from local storage: $e');
      return null;
    }
  }

  @override
  Future<List<String>> getMyCrushes() async {
    try {
      final data = await readPrivateData();
      return data?.crushEmailList ?? [];
    } catch (e) {
      log('Error getting crushes from local storage: $e');
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
      log('Crush added to local storage: $email');
    } catch (e) {
      log('Error adding crush to local storage: $e');
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
        log('Crush removed from local storage at index: $index');
      }
    } catch (e) {
      log('Error removing crush from local storage: $e');
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
      log('DH private key uploaded to local storage');
    } catch (e) {
      log('Error uploading DH private key to local storage: $e');
      rethrow;
    }
  }

  @override
  Future<String?> getDHPrivateKey() async {
    try {
      final data = await readPrivateData();
      return data?.diffieHellmanPrivateKey;
    } catch (e) {
      log('Error getting DH private key from local storage: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _secureStorage.delete(key: _privateDataKey);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('viewed_events');

      log('Local storage cleared');
    } catch (e) {
      log('Error clearing local storage: $e');
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

  @override
  Future<List<String>> getViewedEventIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('viewed_events') ?? [];
    } catch (e) {
      log('Error getting viewed events from local storage: $e');
      return [];
    }
  }

  @override
  Future<void> markEventAsViewed(String eventId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final viewedEvents = prefs.getStringList('viewed_events') ?? [];
      if (!viewedEvents.contains(eventId)) {
        viewedEvents.add(eventId);
        await prefs.setStringList('viewed_events', viewedEvents);
        log('Event marked as viewed: $eventId');
      }
    } catch (e) {
      log('Error marking event as viewed: $e');
    }
  }
}
