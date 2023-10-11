class Endpoints {
  static const baseUrl = 'http://192.168.54.67:3000';
  static const apiSecurityKey = '';
  static getHeader(){
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}