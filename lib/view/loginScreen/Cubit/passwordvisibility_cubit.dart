import 'package:bloc/bloc.dart';

class PasswordvisibilityCubit extends Cubit<bool> {
  PasswordvisibilityCubit() : super(true);

  Switched() {
    emit(!state);
  }
}
