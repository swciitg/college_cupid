class Endpoints {
  static const baseUrl = 'https://swc.iitg.ac.in/collegeCupid';
  static const apiSecurityKey = '';

  // static const baseUrl = 'http://192.168.0.142:3000';
  static const oneStopbaseUrl = 'https://swc.iitg.ac.in/onestop/api/v3';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}
