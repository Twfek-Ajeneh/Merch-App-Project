import 'package:bloc/bloc.dart';

class ImageCubit extends Cubit<bool> {
  ImageCubit() : super(false);

  Change() {
    emit(!state);
  }
}
