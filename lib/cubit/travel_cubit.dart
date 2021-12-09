import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/services/travel_service.dart';

part 'travel_state.dart';

class TravelCubit extends Cubit<TravelState> {
  TravelCubit() : super(TravelInitial());

  void addTravel({
    required String nama,
    required String biaya,
    required String kelas,
    required String spesifikasi,
    required String fasilitas,
    required String imageUrl,
    required String supir,
  }) async {
    emit(TravelLoading());

    int randomNumber = Random().nextInt(9999999);
    String id = 'travel-$randomNumber';
    TravelModel data = TravelModel(
      id: id,
      nama: nama,
      biaya: biaya,
      kelas: kelas,
      spesifikasi: spesifikasi,
      fasilitas: fasilitas,
      imageUrl: imageUrl,
      supir: supir,
    );

    await TravelService().addTravel(data: data).then((value) {
      emit(TravelSuccessAdd(value));
    }).catchError((onError) {
      emit(TravelError(onError));
    });
  }

  void editTravel({
    required String id,
    required String nama,
    required String biaya,
    required String kelas,
    required String spesifikasi,
    required String fasilitas,
    required String imageUrl,
  }) async {
    emit(TravelLoading());

    TravelModel data = TravelModel(
      id: id,
      nama: nama,
      biaya: biaya,
      kelas: kelas,
      spesifikasi: spesifikasi,
      fasilitas: fasilitas,
      imageUrl: imageUrl,
      supir: '',
    );

    await TravelService().editTravel(data: data).then((value) {
      emit(TravelSuccessEdit(value));
    }).catchError((onError) {
      emit(TravelError(onError));
    });
  }

  void getListTravel() async {
    try {
      emit(TravelLoading());

      List<TravelModel> list = await TravelService().getListTravel();

      if (list.isNotEmpty) {
        emit(TravelSuccess(list));
      } else {
        emit(const TravelError('Belum ada data travel'));
      }
    } catch (e) {
      emit(TravelError(e.toString()));
    }
  }
}
