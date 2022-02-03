import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/model/product.dart';
import 'package:project/view/addProductScreen/add_product_api.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  Future<void> add({required Product product}) async {
    emit(AddProductWaiting());
    try {
      Response response = await AddProductApi.add(product: product);
      if (response.statusCode == 200) {
        debugPrint("Product added successfully");
        if(!isClosed) emit(AddProductSuccess());
      } else
        emit(AddProductFailed());
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("Product added failed");
      try {
        if (e.response!.statusCode == 422) {
          var map = e.response!.data;
          var error = map['errors'][map['errors'].keys.first];
          if(!isClosed) emit(AddProductFailed(exception: error));
        } else
          emit(AddProductFailed());
      } catch (e) {
        emit(AddProductFailed());
      }
    } catch (e) {
      emit(AddProductFailed());
    }
  }
}
