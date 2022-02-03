part of 'login_cubit.dart';

@immutable
abstract class LogInState {}

class LogInInitial extends LogInState {}

class LogInWaiting extends LogInState {}

class LogInSuccess extends LogInState {}

class LogInFailed extends LogInState {
  final String exception;

  LogInFailed({this.exception = "Something went wrong",});
}
