import 'package:store_app/data/local_datasource/auth_local_datasource.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/remote_datasource/auth_remote_datasource.dart';
import 'package:store_app/providers/base_provider.dart';

class AuthProvider extends BaseProvider {
  // final _googleSignIn = GoogleSignIn();
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;
  final UserLocalDatasource userLocalDatasource;

  String authTask = 'authTask';

  String? _authToken;
  String? _currentUserId;

  AuthProvider({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
    required this.userLocalDatasource,
  });

  String? get authToken => this._authToken;
  String? get currentUserId => this._currentUserId;

  bool get isLoggedIn => this._authToken != null && this._currentUserId != null;

  Future<void> getLocalToken() async {
    _authToken = await authLocalDatasource.getToken();
    notifyListeners();
  }

  Future<void> getLocalUserId() async {
    _currentUserId = await authLocalDatasource.getUserId();
    notifyListeners();
  }

  Future<void> resetPassword({required String email}) async {
    throw UnimplementedError();
  }
}
