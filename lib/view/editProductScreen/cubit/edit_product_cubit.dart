import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/model/product.dart';
import 'package:project/view/editProductScreen/edit_product_api.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit() : super(EditProductInitial());

  Future<void> edit({required Product product}) async {
    emit(EditProductWaiting());
    try {
      Response response = await EditProductApi.edit_product(product: product);
      if (response.statusCode == 200) {
        debugPrint("Product edited successfully");
        if(!isClosed) emit(EditProductSuccess());
      } else
        emit(EditProductFailed());
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("product edit failed");
      try {
        if (e.response!.statusCode == 422) {
          var map = e.response!.data;
          var error = map['errors'][map['errors'].keys.first];
          if(!isClosed) emit(EditProductFailed(exception: error));
        } else
          emit(EditProductFailed());
      } catch (e) {
        emit(EditProductFailed());
      }
    } catch (e) {
      emit(EditProductFailed());
    }
  }
}
