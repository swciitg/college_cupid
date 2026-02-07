import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:college_cupid/domain/models/drive_data.dart';
import 'package:college_cupid/services/secure_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

/// Service for managing user data in Google Drive using Firebase Auth
/// Firebase is used only for authentication, data is stored in Google Drive
class FirebaseDriveService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      drive.DriveApi.driveFileScope,
      drive.DriveApi.driveAppdataScope,
    ],
  );

  static drive.DriveApi? _driveApi;
  static String? _appFolderId;
  static String? _userDataFileId; // ID of the user_keys.json file
  static String? _accessToken;
  static String? _refreshToken;

  /// Sign in with Google and initialize both Firebase Auth and Google Drive
  /// [loginHint] can be used to pre-select a specific Google account
  static Future<Map<String, String>> signInAndInitialize({String? loginHint}) async {
    try {
      // Configure GoogleSignIn with loginHint if provided
      final googleSignIn = loginHint != null
          ? GoogleSignIn(
              scopes: [
                'email',
                'profile',
                drive.DriveApi.driveFileScope,
                drive.DriveApi.driveAppdataScope,
              ],
            )
          : _googleSignIn;

      // Sign in with Google
      GoogleSignInAccount? googleUser;
      if (loginHint != null) {
        // Try to sign in silently first with the hint
        googleUser = await googleSignIn.signInSilently();
        // If silent sign-in fails or returns different account, show account picker
        if (googleUser == null || googleUser.email != loginHint) {
          googleUser = await googleSignIn.signIn();
        }
      } else {
        googleUser = await googleSignIn.signIn();
      }

      if (googleUser == null) {
        throw Exception('Sign in cancelled by user');
      }

      // Verify the account matches the loginHint if provided
      if (loginHint != null && googleUser.email != loginHint) {
        await googleSignIn.signOut();
        throw Exception('Please sign in with the account: $loginHint');
      }

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      _accessToken = googleAuth.accessToken;
      _refreshToken = googleUser.serverAuthCode; // This can be used for refresh

      if (_accessToken == null) {
        throw Exception('Failed to get access token');
      }

      // Store tokens securely
      await SecureStorageService.setGoogleAccessToken(_accessToken!);
      if (_refreshToken != null) {
        await SecureStorageService.setGoogleRefreshToken(_refreshToken!);
      }

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final userId = userCredential.user?.uid;

      if (userId == null) {
        throw Exception('Failed to get user ID');
      }

      // Create authenticated HTTP client for Google Drive
      final authClient = GoogleAuthClient({
        'Authorization': 'Bearer $_accessToken',
      });

      _driveApi = drive.DriveApi(authClient);

      // Create or get app folder in Google Drive
      _appFolderId = await _getOrCreateAppFolder();

      // Try to find existing user_keys.json file
      await _findUserDataFile();

      log('Successfully signed in. User ID: $userId, Folder ID: $_appFolderId');

      return {
        'userId': userId,
        'folderId': _appFolderId!,
        'email': userCredential.user?.email ?? '',
        'token': _accessToken!,
      };
    } catch (e) {
      log('Error signing in: $e');
      rethrow;
    }
  }

  /// Get or create the app folder in Google Drive
  static Future<String> _getOrCreateAppFolder() async {
    if (_driveApi == null) {
      throw Exception('Drive API not initialized');
    }

    const folderName = 'CollegeCupidData';

    // Search for existing folder
    const query =
        "name='$folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";
    final fileList = await _driveApi!.files.list(
      q: query,
      spaces: 'drive',
      $fields: 'files(id, name)',
    );

    if (fileList.files != null && fileList.files!.isNotEmpty) {
      log('Found existing folder: ${fileList.files!.first.id}');
      return fileList.files!.first.id!;
    }

    // Create folder if it doesn't exist
    final folder = drive.File();
    folder.name = folderName;
    folder.mimeType = 'application/vnd.google-apps.folder';

    final createdFolder = await _driveApi!.files.create(folder);
    log('Created new folder: ${createdFolder.id}');
    return createdFolder.id!;
  }

  /// Find existing user_keys.json file in the app folder
  static Future<void> _findUserDataFile() async {
    if (_driveApi == null || _appFolderId == null) {
      return;
    }

    try {
      const fileName = 'user_keys.json';
      final query = "name='$fileName' and '$_appFolderId' in parents and trashed=false";
      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name)',
      );

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        _userDataFileId = fileList.files!.first.id;
        log('Found existing user_keys.json: $_userDataFileId');
      }
    } catch (e) {
      log('Could not find user_keys.json: $e');
    }
  }

  /// Upload private data (DH key and crush list)
  static Future<void> uploadPrivateData(DriveData data) async {
    if (_driveApi == null || _appFolderId == null) {
      throw Exception('Drive API not initialized. Call signInAndInitialize first.');
    }

    try {
      const fileName = 'user_keys.json';
      final jsonContent = jsonEncode(data.toJSON());
      final bytes = utf8.encode(jsonContent);
      final media = drive.Media(Stream.value(bytes), bytes.length);

      if (_userDataFileId != null) {
        // Update existing file
        await _driveApi!.files.update(
          drive.File(),
          _userDataFileId!,
          uploadMedia: media,
        );
        log('Updated user_keys.json');
      } else {
        // Create new file
        final driveFile = drive.File();
        driveFile.name = fileName;
        driveFile.parents = [_appFolderId!];

        final response = await _driveApi!.files.create(
          driveFile,
          uploadMedia: media,
        );

        _userDataFileId = response.id;
        log('Created user_keys.json: $_userDataFileId');
      }
    } catch (e) {
      log('Error uploading private data: $e');
      rethrow;
    }
  }

  /// Read private data (DH key and crush list)
  static Future<DriveData?> readPrivateData() async {
    if (_driveApi == null) {
      throw Exception('Drive API not initialized');
    }

    try {
      // Try to find the file if we don't have the ID
      if (_userDataFileId == null) {
        await _findUserDataFile();
      }

      if (_userDataFileId == null) {
        log('user_keys.json not found');
        return null;
      }

      final drive.Media? file = await _driveApi!.files.get(
        _userDataFileId!,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media?;

      if (file == null) {
        throw Exception('File not found');
      }

      final List<int> dataStore = [];
      await for (var data in file.stream) {
        dataStore.addAll(data);
      }

      final jsonString = utf8.decode(dataStore);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      return DriveData.fromJSON(jsonData);
    } catch (e) {
      log('Error reading private data: $e');
      rethrow;
    }
  }

  /// Get list of crush emails
  static Future<List<String>> getMyCrushes() async {
    final data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from Google Drive!");
    }
    return data.crushEmailList;
  }

  /// Add a crush email to the list
  static Future<void> addCrush(String email) async {
    var data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from Google Drive!");
    }
    if (data.crushEmailList.contains(email)) {
      throw Exception("Email already present in the list!");
    }
    data.crushEmailList.add(email);
    return uploadPrivateData(data);
  }

  /// Remove a crush by index
  static Future<void> removeCrush(int index) async {
    var data = await readPrivateData();
    if (data == null) {
      throw Exception("File missing from Google Drive!");
    }
    if (data.crushEmailList.length <= index || index < 0) {
      throw Exception("Index out of bounds!");
    }
    data.crushEmailList.removeAt(index);
    return uploadPrivateData(data);
  }

  /// Upload DH Private Key (replacing OneDrive functionality)
  static Future<void> uploadDHPrivateKey(String dhPrivateKey) async {
    return uploadPrivateData(DriveData(
      crushEmailList: [],
      diffieHellmanPrivateKey: dhPrivateKey,
    ));
  }

  /// Get DH Private Key
  static Future<String?> getDHPrivateKey() async {
    return (await readPrivateData())?.diffieHellmanPrivateKey;
  }

  /// Upload text data to Google Drive
  static Future<String> uploadTextData(String content, String fileName) async {
    if (_driveApi == null || _appFolderId == null) {
      throw Exception('Drive API not initialized. Call signInAndInitialize first.');
    }

    try {
      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = [_appFolderId!];

      final bytes = utf8.encode(content);
      final media = drive.Media(Stream.value(bytes), bytes.length);

      final response = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      log('Text data uploaded: ${response.id}');
      return response.id!;
    } catch (e) {
      log('Error uploading text data: $e');
      rethrow;
    }
  }

  /// Upload a file to Google Drive
  static Future<String> uploadFile(File file, String fileName) async {
    if (_driveApi == null || _appFolderId == null) {
      throw Exception('Drive API not initialized. Call signInAndInitialize first.');
    }

    try {
      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = [_appFolderId!];

      final media = drive.Media(file.openRead(), file.lengthSync());

      final response = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      log('File uploaded: ${response.id}');
      return response.id!;
    } catch (e) {
      log('Error uploading file: $e');
      rethrow;
    }
  }

  /// Download text data from Google Drive
  static Future<String> downloadTextData(String fileId) async {
    if (_driveApi == null) {
      throw Exception('Drive API not initialized');
    }

    try {
      final drive.Media? file = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media?;

      if (file == null) {
        throw Exception('File not found');
      }

      final List<int> dataStore = [];
      await for (var data in file.stream) {
        dataStore.addAll(data);
      }

      return utf8.decode(dataStore);
    } catch (e) {
      log('Error downloading text data: $e');
      rethrow;
    }
  }

  /// Update existing file in Google Drive
  static Future<void> updateFile(String fileId, String content) async {
    if (_driveApi == null) {
      throw Exception('Drive API not initialized');
    }

    try {
      final bytes = utf8.encode(content);
      final media = drive.Media(Stream.value(bytes), bytes.length);

      await _driveApi!.files.update(
        drive.File(),
        fileId,
        uploadMedia: media,
      );

      log('File updated: $fileId');
    } catch (e) {
      log('Error updating file: $e');
      rethrow;
    }
  }

  /// Delete file from Google Drive
  static Future<void> deleteFile(String fileId) async {
    if (_driveApi == null) {
      throw Exception('Drive API not initialized');
    }

    try {
      await _driveApi!.files.delete(fileId);
      log('File deleted: $fileId');
    } catch (e) {
      log('Error deleting file: $e');
      rethrow;
    }
  }

  /// List files in app folder
  static Future<List<drive.File>> listFiles() async {
    if (_driveApi == null || _appFolderId == null) {
      throw Exception('Drive API not initialized');
    }

    try {
      final query = "'$_appFolderId' in parents and trashed=false";
      final fileList = await _driveApi!.files.list(
        q: query,
        spaces: 'drive',
        $fields: 'files(id, name, createdTime, modifiedTime, size)',
      );

      return fileList.files ?? [];
    } catch (e) {
      log('Error listing files: $e');
      rethrow;
    }
  }

  /// Sign out from Google and Firebase
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Clear stored tokens
      await SecureStorageService.setGoogleAccessToken('');
      await SecureStorageService.setGoogleRefreshToken('');

      _driveApi = null;
      _appFolderId = null;
      _userDataFileId = null;
      _accessToken = null;
      _refreshToken = null;
      log('Signed out successfully');
    } catch (e) {
      log('Error signing out: $e');
      rethrow;
    }
  }

  /// Refresh the access token using Google Sign-In
  static Future<bool> refreshAccessToken() async {
    try {
      // Try to sign in silently to refresh the token
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account == null) {
        log('Silent sign-in failed, requires user interaction');
        return false;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      _accessToken = auth.accessToken;

      if (_accessToken == null) {
        return false;
      }

      // Store new access token
      await SecureStorageService.setGoogleAccessToken(_accessToken!);

      // Update the Drive API client with new token
      final authClient = GoogleAuthClient({
        'Authorization': 'Bearer $_accessToken',
      });
      _driveApi = drive.DriveApi(authClient);

      log('Access token refreshed successfully');
      return true;
    } catch (e) {
      log('Error refreshing access token: $e');
      return false;
    }
  }

  /// Initialize Drive API using existing Firebase Auth session
  /// Firebase Auth persists across app restarts, so we leverage that
  static Future<bool> initializeWithStoredTokens() async {
    try {
      // Firebase user persists - if they're signed in, we have access
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        log('No Firebase user - user not signed in');
        return false;
      }

      log('Firebase user found: ${firebaseUser.email}');

      // Try silent sign-in first - this gets fresh tokens if Google session is active
      final GoogleSignInAccount? account = await _googleSignIn.signInSilently();

      if (account != null) {
        log('Silent sign-in successful');
        final auth = await account.authentication;

        if (auth.accessToken != null) {
          _accessToken = auth.accessToken;
          await SecureStorageService.setGoogleAccessToken(_accessToken!);

          // Initialize Drive API
          final authClient = GoogleAuthClient({
            'Authorization': 'Bearer $_accessToken',
          });
          _driveApi = drive.DriveApi(authClient);
          _appFolderId = await _getOrCreateAppFolder();
          await _findUserDataFile();

          log('✓ Drive session restored successfully');
          return true;
        }
      }

      // Fallback: Try using stored token
      log('Silent sign-in unavailable, trying stored token');
      final storedAccessToken = await SecureStorageService.getGoogleAccessToken();

      if (storedAccessToken != null && storedAccessToken.isNotEmpty) {
        _accessToken = storedAccessToken;

        final authClient = GoogleAuthClient({
          'Authorization': 'Bearer $_accessToken',
        });
        _driveApi = drive.DriveApi(authClient);

        try {
          // Validate token by testing Drive access
          _appFolderId = await _getOrCreateAppFolder();
          await _findUserDataFile();

          log('✓ Drive restored with stored token');
          return true;
        } catch (e) {
          log('Stored token expired: $e');
          // Clear invalid credentials
          _driveApi = null;
          _accessToken = null;
          await SecureStorageService.clearGoogleTokens();
          return false;
        }
      }

      log('No valid tokens available - re-authentication required');
      return false;
    } catch (e) {
      log('Drive initialization error: $e');
      _driveApi = null;
      _accessToken = null;
      return false;
    }
  }

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    final user = _auth.currentUser;
    final isGoogleSignedIn = await _googleSignIn.isSignedIn();
    return user != null && isGoogleSignedIn;
  }

  /// Get app folder ID
  static String? get appFolderId => _appFolderId;

  /// Get access token
  static String? get accessToken => _accessToken;
}

/// Custom HTTP client for Google Sign-In authentication
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
