import 'package:bloc/bloc.dart';

class PageCubit extends Cubit<int> {
  PageCubit() : super(0);

  void setPage(int newPage) {
    emit(newPage);
  }

  void reset() {
    emit(0);
  }
}
