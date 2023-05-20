import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:store_app/core/error/exceptions.dart';
import 'package:store_app/data/local_datasource/auth_local_datasource.dart';
import 'package:store_app/data/local_datasource/cart_local_datasource.dart';
import 'package:store_app/data/local_datasource/sqflite_handler.dart';
import 'package:store_app/data/local_datasource/user_local_datasource.dart';
import 'package:store_app/data/local_datasource/wishlist_local_datasource.dart';
import 'package:store_app/data/remote_datasource/auth_remote_datasource.dart';
import 'package:store_app/utils/user_form_validator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;
  final UserLocalDatasource userLocalDatasource;
  final WishlistLocalDatasource wishlistLocalDatasource;
  final CartLocalDatasource cartLocalDatasource;
  final UserFormValidator userFormValidator;
  final SQFLiteHandler sqfLiteHandler;

  AuthBloc({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
    required this.userLocalDatasource,
    required this.cartLocalDatasource,
    required this.wishlistLocalDatasource,
    required this.userFormValidator,
    required this.sqfLiteHandler,
  }) : super(AuthUnauthenticated()) {
    on<SignInWithEmailEvent>((event, emit) async {
      emit(AuthLoading(message: 'Signing In'));
      try {
        final authModel = await authRemoteDatasource.login(
            email: event.email, password: event.password);
        await authLocalDatasource.safeTokenAndUserId(
            token: authModel.token, userId: authModel.user.id);
        emit(AuthAuthenticated(
            authToken: authModel.token, userId: authModel.user.id));
      } on ServerException catch (e) {
        emit(AuthError(errorMessage: e.message));
      } catch (e) {
        emit(AuthError(errorMessage: e.toString()));
      }
    });
    on<SignUpWithEmailEvent>((event, emit) async {
      try {
        userFormValidator.validate(
            name: event.name, email: event.email, password: event.password);
        emit(AuthLoading(message: 'Processing'));
        final authModel = await authRemoteDatasource.register(
            email: event.email, name: event.name, password: event.password);
        await authLocalDatasource.safeTokenAndUserId(
            token: authModel.token, userId: authModel.user.id);
        emit(AuthAuthenticated(
            authToken: authModel.token, userId: authModel.user.id));
      } on InputException catch (e) {
        emit(AuthError.fromInputException(e));
      } on ServerException catch (e) {
        emit(AuthError(errorMessage: e.message));
      } catch (e) {
        emit(AuthError(errorMessage: e.toString()));
      }
    });

    on<ContinueWithGoogleEvent>((event, emit) async {
      try {
        emit(AuthLoading(message: 'Processing'));
        final authModel = await authRemoteDatasource.continueWithGoogle();
        await authLocalDatasource.safeTokenAndUserId(
            token: authModel.token, userId: authModel.user.id);
        emit(AuthAuthenticated(
            authToken: authModel.token, userId: authModel.user.id));
      } on ServerException catch (e) {
        emit(AuthError(errorMessage: e.message));
      } catch (e) {
        emit(AuthError(errorMessage: e.toString()));
      }
    });

    on<GetAuthStatusEvent>((event, emit) async {
      final authToken = await authLocalDatasource.getToken();
      final userId = await authLocalDatasource.getUserId();

      if (authToken != null && userId != null) {
        emit(AuthAuthenticated(authToken: authToken, userId: userId));
      }
    });

    on<SignOutEvent>((event, emit) async {
      if (state is AuthAuthenticated) {
        final current = state as AuthAuthenticated;
        emit(SignOutLoading(message: 'Signing Out'));

        try {
          await authRemoteDatasource.signOut(current.authToken);
          await authLocalDatasource.deleteTokenandUserId();

          if (!kIsWeb) {
            await sqfLiteHandler.deleteStoreAppDatabase();
          }
          emit(AuthUnauthenticated());
        } on ServerException catch (e) {
          emit(AuthError(errorMessage: e.message));
        } catch (e) {
          print(e.toString());
          emit(AuthError(errorMessage: e.toString()));
        }
      }
    });

    //TODO : Implement Reset Password
    on<ResetPasswordEvent>((event, emit) async {});
  }
}
