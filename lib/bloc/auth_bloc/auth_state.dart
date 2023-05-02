part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoading extends AuthState {
  final String message;

  AuthLoading({required this.message});
}

class AuthAuthenticated extends AuthState {
  final String authToken;
  final String userId;

  AuthAuthenticated({required this.authToken, required this.userId});
}

class SignOutLoading extends AuthState {
  final String message;

  SignOutLoading({required this.message});
}

// ignore: must_be_immutable
class AuthError extends AuthState {
  final String errorMessage;
  String? emailError;
  String? nameError;
  String? passwordError;

  AuthError({
    required this.errorMessage,
    this.emailError,
    this.nameError,
    this.passwordError,
  });

  factory AuthError.fromInputException(InputException inputException) {
    return AuthError(
      errorMessage: inputException.message,
      emailError: inputException.error.containsKey('email')
          ? inputException.error['email']
          : null,
      nameError: inputException.error.containsKey('name')
          ? inputException.error['name']
          : null,
      passwordError: inputException.error.containsKey('password')
          ? inputException.error['password']
          : null,
    );
  }
}
