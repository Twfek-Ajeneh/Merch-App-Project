part of 'signup_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpWaiting extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailed extends SignUpState {
  final String exception;

  SignUpFailed({this.exception = "Something went wrong",});
}