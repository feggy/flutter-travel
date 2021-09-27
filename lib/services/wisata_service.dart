import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/wisata_model.dart';

class WisataService {
  final CollectionReference _wisataReference =
      FirebaseFirestore.instance.collection('wisata');

  Future<String> addWisata({required WisataModel data}) async {
    try {
      String response = '';
      List<Map<String, dynamic>> agendaMap = data.agenda
          .map((e) => {
                'dayOfNumber': e.dayOfNumber,
                'agenda': e.agenda
                    .map((e) => {
                          'dayOfNumber': e.dayOfNumber,
                          'startTime': e.startTime,
                          'endTime': e.endTime,
                          'deskripsi': e.deskripsi,
                        })
                    .toList(),
              })
          .toList();

      await _wisataReference.add({
        'id': data.id,
        'nama': data.nama,
        'biaya': data.biaya,
        'deskripsiHari': data.deskripsiHari,
        'imageUrl': data.imageUrl,
        'agenda': agendaMap,
      }).then((value) {
        log('wisata berhasil di tambahkan');
        response = 'Berhasil menambahkan data wisata baru';
      }).catchError((error) {
        log('gagal menambahkan $error');
        response = 'Gagal menambahkan data wisata\nERROR $error';
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WisataModel>> getListWisata() async {
    try {
      QuerySnapshot result = await _wisataReference.get();

      List<WisataModel> listWisata = result.docs.map((e) {
        return WisataModel.fromJson(e.data() as Map<String, dynamic>);
      }).toList();
      log('$listWisata');

      return listWisata;
    } catch (e) {
      log('error $e');
      rethrow;
    }
  }

  Future<WisataModel> getListWisataById({required String id}) async {
    try {
      QuerySnapshot result =
          await _wisataReference.where('id', isEqualTo: id).get();

      List<WisataModel> data = result.docs
          .map((e) => WisataModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return data[0];
    } catch (e) {
      rethrow;
    }
  }
}
