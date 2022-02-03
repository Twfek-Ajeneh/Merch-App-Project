import 'package:dio/dio.dart';
import 'package:project/api.dart';

class MyProductsApi {
  static Future<Response> get_products() async {
    Response response = await Api.dio_2.get(
      '/api/product/user',
    );
    return response;
  }
}
