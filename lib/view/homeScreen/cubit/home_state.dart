part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeWaiting extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Product> products;

  HomeSuccess({required this.products});
}

class HomeFailed extends HomeState {
  final String exception;

  HomeFailed({this.exception = "Something went wrong",});
}
