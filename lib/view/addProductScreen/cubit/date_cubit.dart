import 'package:bloc/bloc.dart';

class DateCubit extends Cubit<bool> {
  DateCubit() : super(false);

  Change() {
    emit(!state);
  }
}
