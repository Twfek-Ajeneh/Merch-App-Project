import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/api.dart';

class ProductDetailsApi {
  static Future<Response> get_product({required int id}) async {
    Response response = await Api.dio_2.get(
      '/api/product/' + id.toString(),
    );
    return response;
  }

  static Future<Response> delete_product({required int id}) async {
    Response response = await Api.dio_2.post(
      '/api/product/delete/' + id.toString(),
    );
    return response;
  }

  static Future<Response> like_product({required int id}) async {
    Response response = await Api.dio_2.post(
      '/api/product/like/' + id.toString(),
    );
    return response;
  }

  static Future<Response> comment_product({
    required int id,
    required String comment,
  }) async {
    Response response = await Api.dio_2.post(
      '/api/product/comment/' + id.toString(),
      data: json.encode(
        {'comment': comment},
      ),
    );
    return response;
  }
}
