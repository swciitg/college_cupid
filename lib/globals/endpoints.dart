class Endpoints {
  // static const baseUrl = 'https://swc.iitg.ac.in/collegeCupid';
  static const apiSecurityKey = '';

  static const baseUrl = 'http://192.168.0.142:3000';

  // static const baseUrl = 'http://10.19.2.38:3000';
  static const oneStopBaseUrl = 'https://swc.iitg.ac.in/onestop/api/v3';

  static const getAllUsers = '/user';
  static const postMyInfo = '/user';
  static const addCrush = '/crush/add';
  static const microsoftAuth = '/auth/microsoft';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}
