import 'package:dio/dio.dart';
import 'package:project/api.dart';
import 'package:project/model/user.dart';

class SignUpApi {
  static Future<Response> signup({required User user}) async {
    Response response = await Api.dio_1.post(
      '/api/register',
      data: user.toJson(),
    );
    return response;
  }
}
