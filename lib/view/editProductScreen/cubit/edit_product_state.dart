part of 'edit_product_cubit.dart';

@immutable
abstract class EditProductState {}

class EditProductInitial extends EditProductState {}

class EditProductWaiting extends EditProductState {}

class EditProductSuccess extends EditProductState {}

class EditProductFailed extends EditProductState {
  final String exception;

  EditProductFailed({this.exception = "Something went wrong",});
}
