import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/core/network/network_info.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/remote_datasource/user_remote_datasource.dart';
import 'package:store_app/models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

const String ERROR_MESSAGE = 'Something went wrong!';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRemoteDatasource userRemoteDatasource;
  final UserLocalDatasource userLocalDatasource;
  final NetworkInfo networkInfo;
  UserBloc(
      {required this.userRemoteDatasource,
      required this.userLocalDatasource,
      required this.networkInfo})
      : super(UserInitial()) {
    on<FetchUserEvent>((event, emit) async {
      try {
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          if (!(state is UserLoaded)) {
            emit(UserLoading());
          }
          final userData = await userRemoteDatasource.fetchUser(
              id: event.userId, accessToken: event.accessToken);
          if (!kIsWeb) {
            await userLocalDatasource.insertOrUpdateUser(userData);
          }
          emit(UserLoaded(userModel: userData));
        } else {
          final userData = await userLocalDatasource.getUser();
          emit(UserLoaded(userModel: userData));
        }
      } on ServerException catch (e) {
        if (!(state is UserLoaded)) {
          emit(UserError(message: e.message));
        }
      } catch (e) {
        if (!(state is UserLoaded)) {
          emit(UserError(message: ERROR_MESSAGE));
        }
      }
    });
  }
}
