import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:project/view/productDetailsScreen/product_details_api.dart';

part 'delete_state.dart';

class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit() : super(DeleteInitial());

  Future<void> delete_product({required int id}) async {
    emit(DeleteWaiting());
    try {
      Response response = await ProductDetailsApi.delete_product(id: id);
      if (response.statusCode == 200) {
        debugPrint("Product deleted successfully");
        if(!isClosed) emit(DeleteSuccess());
      } else
        emit(DeleteFailed());
    } on DioError catch (e) {
      debugPrint("product delete failed");
      if (e.response!.statusCode == 400) {
        if(!isClosed) emit(DeleteFailed());
      } else
        emit(DeleteFailed());
    } catch (e) {
      emit(DeleteFailed());
    }
  }
}
