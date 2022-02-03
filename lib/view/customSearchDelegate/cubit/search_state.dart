part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchWaiting extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Product> products;

  SearchSuccess({required this.products});
}

class SearchFailed extends SearchState {
  final String exception;

  SearchFailed({this.exception = "Something went wrong"});
}
