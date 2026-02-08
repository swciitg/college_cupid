import 'package:college_cupid/domain/models/storage_type.dart';
import 'package:college_cupid/repositories/google_drive_repository.dart';
import 'package:college_cupid/repositories/local_storage_repository.dart';
import 'package:college_cupid/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current storage type provider
final storageTypeProvider = StateProvider<StorageType>((ref) {
  return StorageType.localStorage; // Default to local storage
});

/// Storage repository provider that returns the appropriate implementation
/// based on the current storage type
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storageType = ref.watch(storageTypeProvider);

  switch (storageType) {
    case StorageType.googleDrive:
      return GoogleDriveRepository();
    case StorageType.localStorage:
      return LocalStorageRepository();
  }
});
