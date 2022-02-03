import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/model/product.dart';
import 'package:project/view/productDetailsScreen/product_details_api.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Product product = Product();

  Future<void> get_product({required int id}) async {
    emit(ProductDetailsWaiting());
    try {
      Response response = await ProductDetailsApi.get_product(id: id);
      if (response.statusCode == 200) {
        debugPrint("Get product by id success");
        product = Product.fromMap(response.data);
        if(!isClosed) emit(ProductDetailsSuccess(product: product));
      } else
        emit(ProductDetailsFailed());
    } on DioError catch (e) {
      debugPrint("Get product by id faild");
      if(!isClosed) emit(ProductDetailsFailed());
    } catch (e) {
      emit(ProductDetailsFailed());
    }
  }
}
