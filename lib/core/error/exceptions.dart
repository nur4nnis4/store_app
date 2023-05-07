class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class AuthException implements Exception {
  String? message;

  AuthException({this.message});
}

class ConnectionException implements Exception {
  final String message;

  ConnectionException({required this.message});
}

class InputException implements Exception {
  final String message;
  final Map<String, String> error;

  InputException({required this.message, required this.error});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}
