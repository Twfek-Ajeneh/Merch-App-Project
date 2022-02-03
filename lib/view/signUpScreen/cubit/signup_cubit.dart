import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:project/api.dart';

import 'package:project/model/user.dart';
import 'package:project/view/signUpScreen/signup_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> submitted({required User user}) async {
    emit(SignUpWaiting());
    try {
      Response response = await SignUpApi.signup(user: user);
      if (response.statusCode == 200) {
        debugPrint("Sign Up success");
        Api.user = User.fromJson(response.data);
        var token = response.data['token'];
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('token', token);
        await Api.getToken();
        if(!isClosed) emit(SignUpSuccess());
      } else
        emit(SignUpFailed());
    } on DioError catch (e) {
      debugPrint("Sign Up failed");
      debugPrint(e.message);
      try {
        debugPrint(e.response.toString());
        if (e.response!.statusCode == 401) {
          var map = e.response!.data;
          var error = map['errors'][map['errors'].keys.first];
          if(!isClosed) emit(SignUpFailed(exception: error));
        } else
          emit(SignUpFailed());
      } catch (e) {
        emit(SignUpFailed());
      }
    } catch (e) {
      emit(SignUpFailed());
    }
  }
}
