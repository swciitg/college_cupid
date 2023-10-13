enum SplashResponse {
  notAuthenticated('notAuthenticated', 0),
  authenticated('authenticated', 1);

  final String name;
  final int code;

  const SplashResponse(this.name, this.code);
}
