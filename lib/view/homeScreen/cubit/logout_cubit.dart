import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/view/homeScreen/home_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'logout_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit() : super(LogOutInitial());

  Future<void> logout() async {
    emit(LogOutWaiting());
    try {
      Response response = await HomeApi.logout();
      if (response.statusCode == 200) {
        debugPrint("Logout success");
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token", "");
        emit(LogOutSuccess());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("Logout Failed");
      emit(LogOutFailed());
    } catch (e) {
      emit(LogOutFailed());
    }
  }
}
