import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/alamat_travel_model.dart';
import 'package:travel_wisata/models/travel_model.dart';

class TravelService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('travel');
  final CollectionReference _refJemput =
      FirebaseFirestore.instance.collection('jemput');

  Future<String> addTravel({required TravelModel data}) async {
    try {
      String response = '';
      await _ref
          .add({
            'id': data.id,
            'nama': data.nama,
            'biaya': data.biaya,
            'kelas': data.kelas,
            'spesifikasi': data.spesifikasi,
            'fasilitas': data.fasilitas,
            'imageUrl': data.imageUrl,
            'supir': data.supir,
          })
          .then((value) => response = 'Berhasil menambahkan data travel')
          .catchError((onError) {
            log('error $onError');
            response = 'Gagal menambahkan data\nERROR $onError';
          });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addJemput({required JemputPenumpang data}) async {
    try {
      String response = '';

      List<Map<String, dynamic>> travelMap = data.listTraveler
          .map((e) => {
                'nama': e.nama,
                'umur': e.umur,
                'jenisKelamin': e.jenisKelamin,
              })
          .toList();

      await _refJemput
          .add({
            'idTravel': data.idTravel,
            'idInvoice': data.idInvoice,
            'lat': data.lat,
            'lng': data.lng,
            'status': data.status,
            'alamat': data.alamat,
            'namaUser': data.namaUser,
            'phoneUser': data.phoneUser,
            'listTraveler': travelMap,
          })
          .then((value) => response = 'Berhasil meminta jemputan')
          .catchError((onError) => response = 'Gagal $onError');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<JemputPenumpang?> getPenunmpang(
      String idTravel, String idInvoice) async {
    try {
      JemputPenumpang? data;
      await _refJemput
          .where('idTravel', isEqualTo: idTravel)
          .where('idInvoice', isEqualTo: idInvoice)
          .get()
          .then((value) {
        data = value.docs
            .map((e) =>
                JemputPenumpang.fromMap(e.data() as Map<String, dynamic>))
            .toList()[0];
      }).catchError((onError) => log('ERROR $onError'));
      log('GET $data');

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TravelModel>> getListTravel() async {
    try {
      QuerySnapshot result = await _ref.get();

      List<TravelModel> list = result.docs.map((e) {
        return TravelModel.fromMap(e.data() as Map<String, dynamic>);
      }).toList();
      log('$list');

      return list;
    } catch (e) {
      log('error $e');
      rethrow;
    }
  }

  Future<TravelModel> getListTravelById({
    required String id,
  }) async {
    try {
      QuerySnapshot result = await _ref.where('id', isEqualTo: id).get();

      var data = result.docs
          .map((e) => TravelModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      return data[0];
    } catch (e) {
      rethrow;
    }
  }
}
