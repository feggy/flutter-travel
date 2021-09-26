import 'package:bloc/bloc.dart';

class JumlahKursiCubit extends Cubit<int> {
  JumlahKursiCubit() : super(1);

  void add(int value) {
    emit(state + 1);
  }

  void min(int value) {
    if (state != 1) {
      emit(state - 1);
    }
  }

  void reset() {
    emit(1);
  }
}
