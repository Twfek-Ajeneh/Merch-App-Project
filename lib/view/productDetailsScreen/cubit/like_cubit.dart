import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/view/productDetailsScreen/product_details_api.dart';

class LikeCubit extends Cubit<bool> {
  LikeCubit() : super(true);

  Change({required int id}) async {
    try {
      Response response = await ProductDetailsApi.like_product(id: id);
      if (response.statusCode == 200) {
        debugPrint("Like product success");
        if(!isClosed) emit(!state);
      }
    } on DioError catch (e) {
      debugPrint("Like product failed");
    } catch (e) {
      debugPrint("Like product failed");
    }
  }
}
