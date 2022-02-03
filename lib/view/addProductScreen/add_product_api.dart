import 'package:dio/dio.dart';

import 'package:project/api.dart';
import 'package:project/model/product.dart';

class AddProductApi {
  static Future<Response> add({required Product product}) async {
    FormData form_data = await FormData.fromMap(await product.toMap());
    Response response = await Api.dio_2.post(
      '/api/product/create',
      data: form_data,
    );
    return response;
  }
}
