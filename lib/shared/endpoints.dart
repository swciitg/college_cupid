class Endpoints {
  static const baseUrl = 'https://swc.iitg.ac.in/collegeCupid';
  static const apiUrl = 'https://swc.iitg.ac.in/collegeCupid/api/v1';
  static const apiSecurityKey = String.fromEnvironment('SECURITY_KEY');

  static const microsoftAuth = '/auth/microsoft';

  static const postPersonalInfo = '/user/personalInfo';
  static const getPersonalInfo = '/user/personalInfo';
  static const postUserProfile = '/user/profile';
  static const getUserProfile = '/user/profile/email'; // + '/${email}'
  static const getPaginatedUserProfiles =
      '/user/profile/page'; // + '/${pageNumber}'
  static const updateUserProfile = '/user/profile';

  static const addCrush = '/crush/add';
  static const getCrush = '/crush';
  static const removeCrush = '/crush/remove';

  static const getMatch = '/match';

  static const getAllSearchedUserProfiles = '/search/user';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      'security-key': Endpoints.apiSecurityKey
    };
  }
}
