part of 'add_product_cubit.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductWaiting extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductFailed extends AddProductState {
  final String exception;

  AddProductFailed({this.exception = "Something went wrong",});
}
