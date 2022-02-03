import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:project/api.dart';
import 'package:project/view/homeScreen/home_api.dart';

part 'user_image_state.dart';

class UserImageCubit extends Cubit<UserImageState> {
  UserImageCubit() : super(UserImageInitial());

  Future<void> edit_image({required File image}) async {
    emit(UserImageWaiting());
    try {
      Response response = await HomeApi.edit_image(image: image);
      if (response.statusCode == 200) {
        debugPrint("Edit user image success");
        var map = response.data;
        Api.user!.image_url = map['image_url'];
        emit(UserImageSuccess());
      } else
        emit(UserImageFailed());
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint("Edit user image failed");
      try {
        if (e.response!.statusCode == 422) {
          debugPrint(e.response.toString());
          var map = e.response!.data;
          var error = map['errors']['image'];
          emit(UserImageFailed(exception: error));
        }
      } catch (e) {
        emit(UserImageFailed());
      }
    } catch (e) {
      emit(UserImageFailed());
    }
  }

  reset() {
    emit(UserImageInitial());
  }
}
