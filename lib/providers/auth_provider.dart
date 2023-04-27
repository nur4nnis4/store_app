import 'package:flutter/foundation.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/auth_local_datasource.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/remote_datasource/auth_remote_datasource.dart';
import 'package:store_app/data/remote_datasource/user_remote_datasource.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/providers/custom_notifier.dart';

class AuthProvider extends CustomNotifier {
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

  Future<void> signIn({required String email, required String password}) async {
    try {
      final authModel =
          await authRemoteDatasource.login(email: email, password: password);
      _authToken = authModel.token;
      _currentUserId = authModel.user.id;
      await authLocalDatasource.safeTokenAndUserId(
          token: authModel.token, userId: authModel.user.id);
      setStatus(authTask, Status.Done);
    } on ServerException catch (e) {
      setStatus(authTask, Status.Error);
      print(e.message);
    } catch (e) {
      setStatus(authTask, Status.Error);
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getLocalToken() async {
    _authToken = await authLocalDatasource.getToken();
    notifyListeners();
  }

  Future<void> getLocalUserId() async {
    _currentUserId = await authLocalDatasource.getUserId();
    notifyListeners();
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      setStatus(authTask, Status.Loading);
      final authModel = await authRemoteDatasource.register(
          email: email, password: password, name: name);
      _authToken = authModel.token;
      _currentUserId = authModel.user.id;
      if (!kIsWeb) {
        await UserLocalDatasource.instance.insertUser(authModel.user);
      }
      setStatus(authTask, Status.Done);
    } catch (e) {
      setStatus(authTask, Status.Error);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await authRemoteDatasource.signOut(_authToken!);
      if (!kIsWeb) {
        await userLocalDatasource.deleteUser();
      }
      await authLocalDatasource.deleteToken();
      _authToken = null;
      _currentUserId = null;
      setStatus(authTask, Status.Done);
    } catch (e) {
      setStatus(authTask, Status.Error);
    }
    notifyListeners();
  }

  // Google sign in
  Future<void> googleSignIn() async {
    // final googleAccount = await _googleSignIn.signIn();
    // if (googleAccount != null) {
    //   final googleAuth = await googleAccount.authentication;
    //   if (googleAuth.accessToken != null && googleAuth.idToken != null) {
    //     final credential = GoogleAuthProvider.credential(
    //         accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //     final userCredential = await _auth.signInWithCredential(credential);
    //     final user = userCredential.user;

    //     if (user != null) {
    //       UserModel userModel = new UserModel(
    //         id: user.uid,
    //         email: user.email ?? '',
    //         fullName: user.displayName ?? '',
    //         imageUrl: user.photoURL ?? '',
    //         phoneNumber: user.phoneNumber ?? '',
    //       );

    //       await UserDataProvider()
    //           .uploadUserData(userModel)
    //           .then((_) => print('Done Uploading'));
    //       notifyListeners();
    //     }
    //   }
    // }
  }

  //TODO : ImplementReset Password
  Future<void> resetPassword({required String email}) async {
    throw UnimplementedError();
  }
}
