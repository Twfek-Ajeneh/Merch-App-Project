import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  //static user
  static User? user = User();

  // login / signup / token
  static Dio dio_1 = Dio(
    BaseOptions(
      baseUrl: "https://merchappstore.000webhostapp.com",
    ),
  );

  //home / my product / add product / log out / user image / search
  //product details / like / delete / comment / edit product
  static Dio dio_2 = Dio(
    BaseOptions(
      baseUrl: "https://merchappstore.000webhostapp.com",
      headers: {
        'Authorization': "Bearer " + user!.token!,
      },
    ),
  );

  static Future<Response> checkToken({required String token}) async {
    Response response = await dio_1.post(
      '/api/open',
      data: json.encode(
        {
          'token': token,
        },
      ),
    );
    return response;
  }

  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = await preferences.getString('token');
    user!.token = token;
    dio_2 = Dio(
      BaseOptions(
        baseUrl: "https://merchappstore.000webhostapp.com",
        headers: {
          'Authorization': "Bearer " + user!.token!,
        },
      ),
    );
    return;
  }
}
