import 'package:flutter/foundation.dart';
import 'package:store_app/core/network/network_info.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/remote_datasource/user_remote_datasource.dart';
import 'package:store_app/models/user_model.dart';
import 'package:store_app/providers/base_provider.dart';

class UserDataProvider extends BaseProvider {
  final UserRemoteDatasource userRemoteDatasource;
  final UserLocalDatasource userLocalDatasource;
  final NetworkInfo networkInfo;
  UserModel? _userData;

  UserDataProvider({
    required this.userRemoteDatasource,
    required this.userLocalDatasource,
    required this.networkInfo,
  });
  UserModel? get userData => this._userData;

  final String updateUserTask = 'updateUserTask';
  final String fetchUserTask = 'fetchUserTask';
  final String getLocalUserTask = 'getLocalUserTask';

  void setUserData(UserModel user) {
    _userData = user;
    notifyListeners();
  }

  Future<void> fetchUser(
      {required String id, required String accessToken}) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        _userData = await userRemoteDatasource.fetchUser(
            id: id, accessToken: accessToken);
        if (!kIsWeb) {
          await userLocalDatasource.updateUser(_userData!);
        }
      } else {
        _userData = await userLocalDatasource.getUser();
      }
      setStatus(fetchUserTask, Status.Done);
    } catch (e) {
      setStatus(fetchUserTask, Status.Error);
    }
    notifyListeners();
  }
}
