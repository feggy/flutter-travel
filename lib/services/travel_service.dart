import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/travel_model.dart';

class TravelService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('travel');

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
            'imageUrl': data.imageUrl
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
}
