abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(String message) : super(message);
}

class PlatformFailure extends Failure {
  const PlatformFailure(String message) : super(message);
}

class PluginFailure extends Failure {
  PluginFailure(String message) : super(message);
}
