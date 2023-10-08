class Endpoints {
  static const baseUrl = '';
  static const apiSecurityKey = '';
  static getHeader(){
    return {
      'Content-Type': 'application/json',
      // 'security-key': Endpoints.apiSecurityKey
    };
  }
}