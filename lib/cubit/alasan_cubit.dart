import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/alasan_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';

part 'alasan_state.dart';

class AlasanCubit extends Cubit<AlasanState> {
  AlasanCubit() : super(AlasanInitial());

  void reset() {
    emit(AlasanInitial());
  }

  void getAlasan({
    required String idInvoice,
    required String idTravel,
    required String pemandu,
  }) async {
    try {
      emit(LoadingGetAlasan());

      await WisataService()
          .getAlasan(
        idInvoice: idInvoice,
        idTravel: idTravel,
        pemandu: pemandu,
      )
          .then((value) {
        emit(SuccessGetAlasan(value));
      }).catchError((onError) {
        emit(FailedGetAlasan(onError));
      });
    } catch (e) {
      emit(FailedGetAlasan(e.toString()));
    }
  }
}
