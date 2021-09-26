import 'package:bloc/bloc.dart';

class GenderCubit extends Cubit<String> {
  GenderCubit() : super("");

  void selected(String id) {
    emit(id);
  }

  void reset() {
    emit("");
  }

  bool isSelected(String id) {
    if (id == state) {
      return true;
    } else {
      return false;
    }
  }
}
