import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';

part 'wisata_state.dart';

class WisataCubit extends Cubit<WisataState> {
  WisataCubit() : super(WisataInitial());

  void addWisata({
    required String nama,
    required int biaya,
    required String deskripsiHari,
    required String imageUrl,
    required List<HariModel> agenda,
    required String pemandu,
    required List<dynamic> tanggalBerangkat,
  }) async {
    try {
      emit(WisataLoadingAdd());

      int randomNumber = Random().nextInt(9999999);
      String id = 'wisata-$randomNumber';
      WisataModel wisata = WisataModel(
        id: id,
        nama: nama,
        biaya: biaya,
        deskripsiHari: deskripsiHari,
        imageUrl: imageUrl,
        agenda: agenda,
        pemandu: pemandu,
        tanggalBerangkat: tanggalBerangkat,
      );

      await WisataService()
          .addWisata(data: wisata)
          .then((value) => emit(WisataSuccessAdd(value)))
          .catchError((onError) {
        emit(WisataFailedAdd(onError));
      });
    } catch (e) {
      emit(WisataFailedAdd(e.toString()));
    }
  }

  void editWisata({
    required String id,
    required String nama,
    required int biaya,
    required String deskripsiHari,
    required String imageUrl,
    required List<HariModel> agenda,
    required String pemandu,
    required List<dynamic> tanggalBerangkat,
  }) async {
    try {
      emit(WisataLoadingAdd());

      WisataModel wisata = WisataModel(
        id: id,
        nama: nama,
        biaya: biaya,
        deskripsiHari: deskripsiHari,
        imageUrl: imageUrl,
        agenda: agenda,
        pemandu: pemandu,
        tanggalBerangkat: tanggalBerangkat,
      );

      await WisataService()
          .editWisata(data: wisata)
          .then((value) => emit(WisataSuccessEdit(value)))
          .catchError((onError) {
        emit(WisataFailedAdd(e.toString()));
      });
    } catch (e) {
      emit(WisataFailedAdd(e.toString()));
    }
  }

  void getListWisata() async {
    try {
      emit(WisataLoading());

      List<WisataModel> listWisata = await WisataService().getListWisata();

      if (listWisata.isNotEmpty) {
        emit(WisataSuccess(listWisata));
      } else {
        emit(const WisataFailed('Belum ada data wisata'));
      }
    } catch (e) {
      emit(WisataFailed(e.toString()));
    }
  }
}
