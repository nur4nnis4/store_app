import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDatasource {
  final FlutterSecureStorage storage;

  AuthLocalDatasource({required this.storage});

  Future<void> safeTokenAndUserId(
      {required String token, required String userId}) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'user_id', value: userId);
  }

  Future<String?> getToken() async {
    return storage.read(key: 'token');
  }

  Future<String?> getUserId() async {
    return storage.read(key: 'user_id');
  }

  Future<void> deleteTokenandUserId() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'user_id');
  }
}
