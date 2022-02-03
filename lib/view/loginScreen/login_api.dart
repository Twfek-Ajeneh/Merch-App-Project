import 'package:dio/dio.dart';
import 'package:project/api.dart';
import 'package:project/model/user.dart';

class LogInApi {
  static Future<Response> login({required User user}) async {
    Response response = await Api.dio_1.post(
      '/api/login',
      data: user.toJson(),
    );
    return response;
  }
}
