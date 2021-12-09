import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/models/alasan_model.dart';
import 'package:travel_wisata/models/lokasi_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';

class WisataService {
  final CollectionReference _wisataReference =
      FirebaseFirestore.instance.collection('wisata');

  final CollectionReference _locationReference =
      FirebaseFirestore.instance.collection('lokasi');

  final CollectionReference _absenReference =
      FirebaseFirestore.instance.collection('absen');

  final CollectionReference _alasanReference =
      FirebaseFirestore.instance.collection('alasan');

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
        'pemandu': data.pemandu,
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

  Future<bool> editWisata({required WisataModel data}) async {
    try {
      bool status = false;
      var result = await _wisataReference.where('id', isEqualTo: data.id).get();

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

      if (result.docs.isNotEmpty) {
        for (var element in result.docs) {
          var id = element.id;
          await _wisataReference.doc(id).update({
            'nama': data.nama,
            'biaya': data.biaya,
            'deskripsiHari': data.deskripsiHari,
            'imageUrl': data.imageUrl,
            'agenda': agendaMap,
            'pemandu': data.pemandu,
          }).then((value) {
            status = true;
          }).catchError((onError) {
            log('_ $onError');
            status = false;
            log('_ $onError');
          });
        }
      }

      return status;
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

  Future<LokasiModel> getPemanduLokasi(
      {required String idWisata, required String pemandu}) async {
    try {
      QuerySnapshot result = await _locationReference
          .where('idWisata', isEqualTo: idWisata)
          .where('pemandu', isEqualTo: pemandu)
          .get();

      var data = result.docs
          .map((e) => LokasiModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      return data[0];
    } catch (e) {
      log('_ ERR $e');
      rethrow;
    }
  }

  Future<String> shareLocation({required LokasiModel data}) async {
    try {
      String response = '';

      QuerySnapshot result = await _locationReference
          .where('idWisata', isEqualTo: data.idWisata)
          .where('pemandu', isEqualTo: data.pemandu)
          .get();

      var res = result.docs
          .map((e) => LokasiModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      if (res.isEmpty) {
        await _locationReference.add({
          'pemandu': data.pemandu,
          'idWisata': data.idWisata,
          'lat': data.lat,
          'lng': data.lng,
          'timeCreated': data.timeCreated,
        }).then((value) {
          log('Sukses bagikan lokasi');
          response = 'Lokasi berhasil dibagikan';
        }).catchError((onError) {
          log('ERROR $onError');
          response = 'Terjadi masalah $onError';
        });
      } else {
        await _locationReference.doc(result.docs[0].id).update({
          'lat': data.lat,
          'lng': data.lng,
          'timeCreated': data.timeCreated,
        }).then((value) {
          log('Sukses memperbarui lokasi');
          response = 'Lokasi berhasil diperbarui';
        }).catchError((onError) {
          log('ERROR $onError');
          response = 'Terjadi masalah $onError';
        });
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Absen> absenPeserta({required Absen data}) async {
    try {
      String response = '';

      List<Map<String, dynamic>> listAbsen = data.listAbsenPeserta
          .map((e) => {
                'nama': e.nama,
                'status': e.status,
              })
          .toList();

      await _absenReference.add({
        'idInvoice': data.idInvoice,
        'idWisata': data.idWisata,
        'pemandu': data.pemandu,
        'listAbsenPeserta': listAbsen,
        'updated': data.updated,
      }).then((value) {
        response = 'Berhasil mengabsen peserta';
        log(response);
      });

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Absen>> getAbsen({
    required String idInvoice,
    required String idWisata,
    required String pemandu,
  }) async {
    try {
      QuerySnapshot result = await _absenReference
          .orderBy('updated', descending: true)
          .where('idInvoice', isEqualTo: idInvoice)
          .where('idWisata', isEqualTo: idWisata)
          .where('pemandu', isEqualTo: pemandu)
          .get();

      List<Absen> data = result.docs
          .map((e) => Absen.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateAbsen(
      {required String idInvoice,
      required String idWisata,
      required String pemandu,
      required DateTime updated,
      required List<AbsenPeserta> listAbsen}) async {
    try {
      String response = '';
      var result = await _absenReference
          .where('idInvoice', isEqualTo: idInvoice)
          .where('idWisata', isEqualTo: idWisata)
          .where('pemandu', isEqualTo: pemandu)
          .where('updated', isEqualTo: updated)
          .get();

      List<Map<String, dynamic>> listAbsenMap = listAbsen
          .map((e) => {
                'nama': e.nama,
                'status': e.status,
              })
          .toList();

      if (result.docs.isNotEmpty) {
        for (var element in result.docs) {
          var id = element.id;
          await _absenReference
              .doc(id)
              .update({'listAbsenPeserta': listAbsenMap}).then((value) {
            response = 'Absen berhasil disimpan';
          }).catchError((onError) {
            response = 'ERROR $onError';
          });
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateAgenda({
    required String id,
    required String pemandu,
    required List<HariModel> agenda,
    required String idInvoice,
    required String idTravel,
    required String alasan,
  }) async {
    try {
      String response = '';
      var result = await _wisataReference
          .where('id', isEqualTo: id)
          .where('pemandu', isEqualTo: pemandu)
          .get();

      List<Map<String, dynamic>> agendaMap = agenda
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

      if (result.docs.isNotEmpty) {
        for (var element in result.docs) {
          var id = element.id;
          await _wisataReference
              .doc(id)
              .update({'agenda': agendaMap}).then((value) async {
            response = 'Absen berhasil di simpan';

            await addAlasan(
              idInvoice: idInvoice,
              idTravel: idTravel,
              pemandu: pemandu,
              alasan: alasan,
            );
          }).catchError((onError) {
            response = 'ERROR $onError';
          });
        }
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> addAlasan({
    required String idInvoice,
    required String idTravel,
    required String pemandu,
    required String alasan,
  }) async {
    try {
      String response = '';

      await _alasanReference.add({
        'idInvoice': idInvoice,
        'idTravel': idTravel,
        'pemandu': pemandu,
        'alasan': alasan,
        'timeCreated': DateTime.now(),
      }).then((value) {
        response = 'Berhasil menambahkan alasan perubahan agenda';
        log(response);
      }).catchError((onError) {
        log('ERROR $onError');
        response = 'Gagal menambahkan alasan perubahan agenda ERROR $onError';
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AlasanModel>> getAlasan({
    required String idInvoice,
    required String idTravel,
    required String pemandu,
  }) async {
    try {
      QuerySnapshot result = await _alasanReference
          .orderBy('timeCreated', descending: true)
          .where('idInvoice', isEqualTo: idInvoice)
          .where('idTravel', isEqualTo: idTravel)
          .where('pemandu', isEqualTo: pemandu)
          .get();

      List<AlasanModel> data = result.docs
          .map((e) => AlasanModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      log('_ $data');

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
