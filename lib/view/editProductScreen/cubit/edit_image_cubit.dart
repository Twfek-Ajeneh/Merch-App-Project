import 'package:bloc/bloc.dart';

class EditImageCubit extends Cubit<bool> {
  EditImageCubit() : super(false);

  Change() {
    emit(!state);
  }
}
