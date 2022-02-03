part of 'my_products_cubit.dart';

@immutable
abstract class MyProductsState {}

class MyProductsInitial extends MyProductsState {}

class MyProductsWaiting extends MyProductsState {}

class MyProductsSuccess extends MyProductsState {
  final List<Product> products;

  MyProductsSuccess({required this.products});
}

class MyProductsFailed extends MyProductsState {
  final String exception;

  MyProductsFailed({this.exception = "Something went wrong"});
}
