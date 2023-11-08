class Endpoints {
  static const baseUrl = 'https://swc.iitg.ac.in/collegeCupid';
  static const apiSecurityKey = '';

  // static const baseUrl = 'http://192.168.0.141:3000';

  static const microsoftAuth = '/auth/microsoft';

  static const postPersonalInfo = '/user/personalInfo';
  static const getPersonalInfo = '/user/personalInfo';

  static const postUserProfile = '/user/profile';
  static const getUserProfile = '/user/profile/email'; // + '/${email}'
  static const getAllUserProfiles = '/user/profile/all';
  static const updateUserProfile = '/user/profile';

  static const addCrush = '/crush/add';
  static const getCrush = '/crush';
  static const removeCrush = '/crush/remove';
  static const getMatch = '/match';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}
