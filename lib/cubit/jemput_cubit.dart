import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/alamat_travel_model.dart';
import 'package:travel_wisata/services/travel_service.dart';

part 'jemput_state.dart';

class JemputCubit extends Cubit<JemputState> {
  JemputCubit() : super(JemputInitial());

  void reset() {
    emit(JemputInitial());
  }

  void addJemput({required JemputPenumpang data}) async {
    try {
      emit(JemputLoading());

      await TravelService().addJemput(data: data).then((value) {
        emit(JemputSuccessAdd(value));
      }).catchError((onError) {
        emit(JemputFailedAdd(onError));
      });
    } catch (e) {
      emit(JemputFailedAdd(e.toString()));
    }
  }

  void getJemput({required String idTravel, required String idInvoice}) async {
    try {
      await TravelService().getPenunmpang(idTravel, idInvoice).then((value) {
        emit(JemputSuccessGet(value!));
      }).catchError((onError) {
        emit(JemputFailedGet(onError));
      });
    } catch (e) {
      emit(JemputFailedGet(e.toString()));
    }
  }
}
