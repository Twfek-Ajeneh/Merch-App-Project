import 'dart:io';

import 'package:dio/dio.dart';
import 'package:project/api.dart';

class HomeApi {
  static Future<Response> get_products() async {
    Response response = await Api.dio_2.get(
      '/api/product',
    );
    return response;
  }

  static Future<Response> logout() async {
    Response response = await Api.dio_2.post('/api/logout');
    return response;
  }

  static Future<Response> edit_image({required File image}) async {
    FormData form_data = await FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      },
    );
    Response response = await Api.dio_2.post(
      '/api/user',
      data: await form_data,
    );
    return response;
  }
}
