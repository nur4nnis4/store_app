class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class CacheException implements Exception {}

class PluginException implements Exception {}

class ConnectionException implements Exception {
  final String message;

  ConnectionException({required this.message});
}
