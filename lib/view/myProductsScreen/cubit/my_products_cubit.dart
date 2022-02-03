import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/model/product.dart';
import 'package:project/view/myProductsScreen/my_products_api.dart';

part 'my_products_state.dart';

class MyProductsCubit extends Cubit<MyProductsState> {
  MyProductsCubit() : super(MyProductsInitial());

  List<Product> products = [];

  Future<void> get_products() async {
    emit(MyProductsWaiting());
    products.clear();
    try {
      Response response = await MyProductsApi.get_products();
      if (response.statusCode == 200) {
        debugPrint("Get My products Success");
        var map = response.data;
        for (var item in map) {
          products.add(Product.fromMap(item));
        }
        if(!isClosed) emit(MyProductsSuccess(products: products));
      } else
        emit(MyProductsFailed());
    } catch (e) {
      debugPrint(e.toString());
      debugPrint("Get My products failed");
      if(!isClosed) emit(MyProductsFailed());
    }
  }
}
