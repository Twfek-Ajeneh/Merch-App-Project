part of 'delete_cubit.dart';

@immutable
abstract class DeleteState {}

class DeleteInitial extends DeleteState {}

class DeleteWaiting extends DeleteState {}

class DeleteSuccess extends DeleteState {}

class DeleteFailed extends DeleteState {
  final String exception;

  DeleteFailed({this.exception = "Something went wrong"});
}
