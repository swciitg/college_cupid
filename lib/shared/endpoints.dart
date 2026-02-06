class Endpoints {
  static const baseUrl = "https://swc.iitg.ac.in/test/collegeCupid";//String.fromEnvironment('BASE_URL');
  static const apiUrl = "https://swc.iitg.ac.in/test/collegeCupid/api/v2";//String.fromEnvironment('API_URL');
  static const apiSecurityKey = "Cupid-Dev";//String.fromEnvironment('SECURITY_KEY');
  static const wsUrl = String.fromEnvironment('WS_URL');
  

  static const microsoftAuth = '/auth/microsoft';

  static const postPersonalInfo = '/user/personalInfo';
  static const getPersonalInfo = '/user/personalInfo';
  static const postProfileImage = '/uploadImage';

  /// /deleteImage/photoId
  static const deleteProfileImage = '/deleteImage';
  static const postUserProfile = '/user/profile';
  static const getUserProfile = '/user/profile/email'; // + '/${email}'
  static const getPaginatedUserProfiles =
      '/user/profile/page'; // + '/${pageNumber}'
  static const updateUserProfile = '/user/profile';
  static const deactivateAccount = '/user/profile/deactivate';
  static const activateAccount = '/user/profile/reactivate';

  static const postAudioNotes = '/user/voice/upload';
  
  static const addCrush = '/crush/add';
  static const getCrush = '/crush';
  static const removeCrush = '/crush/remove';
  static const getCrushesCount = '/crush/getCount';
  static const increaseCrushesCount = '/crush/increaseCount';
  static const decreaseCrushesCount = '/crush/decreaseCount';

  static const getMatch = '/match';

  static const reportUser = '/report/add';
  static const getBlockedUsers = '/report/blockedUsers';
  static const unblockUser = '/report/unblock';

  // Confessions
  static const getConfessions = '/confession';
  static const getMyConfessions = '/confession/self';
  static const postConfession = '/confession';
  static const deleteConfession = '/confession'; // + '/:id'
  static const deleteConfessionAdmin = '/confession/admin'; // + '/:id'
  static const reportConfession = '/confession/report'; // + '/:id'
  static const reactToConfession = '/confession/react'; // + '/:id'
  static const removeReaction = '/confession/react'; // + '/:id' (DELETE)

  // Replies
  static const postReply = '/reply/add';
  static const getUpdates = '/reply/updates';

  static const regenerateToken = '/auth/refreshToken';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      'security-key': Endpoints.apiSecurityKey
    };
  }

  static getMultipartHeader() {
    return {
      'Content-Type': 'multipart/form-data',
      'security-key': Endpoints.apiSecurityKey
    };
  }
}
