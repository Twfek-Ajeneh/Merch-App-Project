import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:project/model/product.dart';
import 'package:project/view/customSearchDelegate/search_api.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  List<Product> products = [];

  Future<void> search({required String query, required String date}) async {
    emit(SearchWaiting());
    products.clear();
    try {
      Response response = await SearchApi.search(query: query, date: date);
      if (response.statusCode == 200) {
        debugPrint("Search Success");
        var map = response.data;
        for (var item in map) {
          products.add(Product.fromMap(item));
        }
        if(!isClosed) emit(SearchSuccess(products: products));
      } else
        emit(SearchFailed());
    } catch (e) {
      debugPrint("Search fialed");
      debugPrint(e.toString());
      if(!isClosed) emit(SearchFailed());
    }
  }
}
