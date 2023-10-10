class Endpoints {
  static const baseUrl = 'https://swc.iitg.ac.in/collegeCupid';
  static const apiSecurityKey = '';
  static const oneStopbaseUrl = 'https://swc.iitg.ac.in/onestop/api/v3';

  static getHeader() {
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}
