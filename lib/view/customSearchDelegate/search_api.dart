import 'package:dio/dio.dart';
import 'package:project/api.dart';

class SearchApi {
  static Future<Response> search(
      {required String query, required String date}) async {
    Response response = await Api.dio_2.get(
      '/api/product/search',
      queryParameters: {'query': query , 'date' : date},
    );
    return response;
  }
}
