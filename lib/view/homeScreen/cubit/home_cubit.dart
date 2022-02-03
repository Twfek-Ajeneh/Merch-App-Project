import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/model/product.dart';
import 'package:project/view/homeScreen/home_api.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Product> products = [];

  Future<void> get_products() async {
    emit(HomeWaiting());
    products.clear();
    try {
      Response response = await HomeApi.get_products();
      if (response.statusCode == 200) {
        debugPrint("Get all products Success");
        for (var item in response.data) {
          products.add(Product.fromMap(item));
        }
        emit(HomeSuccess(products: products));
      } else
        emit(HomeFailed());
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("Get all products fialed");
      emit(HomeFailed());
    } catch (e) {
      debugPrint(e.toString());
      emit(HomeFailed());
    }
  }

  list_sort(int n) {
    emit(HomeWaiting());
    if (n == 1) {
      products.sort((a, b) => a.name!.compareTo(b.name!));
    } else if (n == 2) {
      products.sort((a, b) => a.price!.compareTo(b.price!));
    } else {
      products.sort((a, b) => a.expires_at!.compareTo(b.expires_at!));
    }
    emit(HomeSuccess(products: products));
  }
}
