part of 'user_image_cubit.dart';

@immutable
abstract class UserImageState {}

class UserImageInitial extends UserImageState {}

class UserImageWaiting extends UserImageState {}

class UserImageSuccess extends UserImageState {}

class UserImageFailed extends UserImageState {
  final String exception;

  UserImageFailed({this.exception = "Something went wrong",});
}
