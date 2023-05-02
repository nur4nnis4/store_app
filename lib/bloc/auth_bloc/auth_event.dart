part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent({required this.email, required this.password});
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String name;
  final String password;

  SignUpWithEmailEvent(
      {required this.email, required this.name, required this.password});
}

class ContinueWithGoogleEvent extends AuthEvent {}

class GetAuthStatusEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
