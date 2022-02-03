part of 'logout_cubit.dart';

@immutable
abstract class LogOutState {}

class LogOutInitial extends LogOutState {}

class LogOutWaiting extends LogOutState {}

class LogOutSuccess extends LogOutState {}

class LogOutFailed extends LogOutState {
  final String exception;

  LogOutFailed({this.exception = "Something went wrong",});
}
