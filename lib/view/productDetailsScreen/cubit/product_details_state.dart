part of 'product_details_cubit.dart';

@immutable
abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsWaiting extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {
  final Product product;

  ProductDetailsSuccess({required this.product});
}

class ProductDetailsFailed extends ProductDetailsState {
  final String exception;

  ProductDetailsFailed({this.exception = "Something went wrong"});
}
