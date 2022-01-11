import 'dart:developer' as d;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/models/laporan_transaksi_model.dart';

class LaporanTransaksiService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('laporan_transaksi');

  Future<bool> add({required LaporanTransaksiModel data}) async {
    var status = false;
    var id = 'p-${Random().nextInt(9999999)}';

    var listPengeluaran = data.listPengeluaran
        .map((e) => {
              'id': e.id,
              'nama': e.nama,
              'qty': e.qty,
              'biaya': e.biaya,
            })
        .toList();

    await _ref.add({
      'id': id,
      'idTravel': data.idTravel,
      'kategori': data.kategori,
      'nama': data.nama,
      'bulan': data.bulan,
      'totalPemasukkan': data.totalPemasukkan,
      'totalPengeluaran': data.totalPengeluaran,
      'listPengeluaran': listPengeluaran,
      'banyakPeserta': data.banyakPeserta,
      'biayaPaket': data.biayaPaket,
      'timeCreated': data.timeCreated,
    }).then((value) {
      d.log('_ $value');
      status = true;
    }).catchError((err) {
      d.log('$err');
      status = false;
    });

    return status;
  }

  Future<List<LaporanTransaksiModel>> get() async {
    try {
      var result = await _ref.get();

      var dataList = result.docs
          .map((e) =>
              LaporanTransaksiModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      return dataList;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkBulan({required String nama, required String bulan}) async {
    try {
      d.log('_!! $bulan');
      var status = false;

      var result = await _ref.where('nama', isEqualTo: nama).get();

      var dataList = result.docs
          .map((e) =>
              LaporanTransaksiModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      for (var element in dataList) {
        var a = DateFormat('MMMM yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                element.bulan.millisecondsSinceEpoch));
        d.log('_ $a');
        if (a == bulan) {
          status = true;
        }
      }

      return status;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> delete({required String id}) async {
    var status = false;
    var result = await _ref.where('id', isEqualTo: id).get();

    var dataList = result.docs
        .map((e) =>
            LaporanTransaksiModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();

    if (result.docs.isNotEmpty) {
      for (var element in result.docs) {
        var id = element.id;
        d.log('_ $id');

        await _ref.doc(id).delete().then((value) {
          status = true;
        }).catchError((onError) {
          status = false;
          d.log('_ $onError');
        });
      }
    }
    return status;
  }
}
