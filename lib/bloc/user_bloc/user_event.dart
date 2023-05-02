part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class FetchUserEvent extends UserEvent {
  final String userId;
  final String accessToken;

  FetchUserEvent({required this.userId, required this.accessToken});
}
