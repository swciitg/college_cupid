/// Storage type enum
enum StorageType {
  googleDrive,
  localStorage,
}

extension StorageTypeExtension on StorageType {
  String get name {
    switch (this) {
      case StorageType.googleDrive:
        return 'Google Drive';
      case StorageType.localStorage:
        return 'Local Storage';
    }
  }

  String get value {
    switch (this) {
      case StorageType.googleDrive:
        return 'GOOGLE_DRIVE';
      case StorageType.localStorage:
        return 'LOCAL_STORAGE';
    }
  }

  static StorageType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'GOOGLE_DRIVE':
        return StorageType.googleDrive;
      case 'LOCAL_STORAGE':
        return StorageType.localStorage;
      default:
        return StorageType.localStorage; // Default to local
    }
  }
}
