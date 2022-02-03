import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/api.dart';
import 'package:project/model/user.dart';
import 'package:project/view/loginScreen/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LogInCubit extends Cubit<LogInState> {
  LogInCubit() : super(LogInInitial());

  Future<void> submitted({required User user}) async {
    emit(LogInWaiting());
    try {
      Response response = await LogInApi.login(user: user);
      if (response.statusCode == 200) {
        debugPrint("Login success");
        Api.user = User.fromJson(response.data);
        var token = response.data['token'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', token);
        await Api.getToken();
        if (!isClosed) emit(LogInSuccess());
      } else {
        emit(LogInFailed());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("Login failed");
      try {
        if (e.response!.statusCode == 401) {
          var map = e.response!.data;
          var error = map['errors'][map['errors'].keys.first];
          if (!isClosed) emit(LogInFailed(exception: error));
        } else
          emit(LogInFailed());
      } catch (e) {
        emit(LogInFailed());
      }
    } catch (e) {
      emit(LogInFailed());
    }
  }
}
