import 'package:bloc/bloc.dart';

class PasswordvisibilitySCubit extends Cubit<bool> {
  PasswordvisibilitySCubit() : super(true);

  Switched() {
    emit(!state);
  }
}
