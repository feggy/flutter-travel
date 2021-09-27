import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/services/travel_service.dart';
import 'package:travel_wisata/services/wisata_service.dart';

class TransactionService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('transaction');

  Future<String> addTransaction({required TransactionModel data}) async {
    try {
      String response = '';

      List<Map<String, dynamic>> travelerMap = data.listTraveler
          .map((e) => {
                'nama': e.nama,
                'umur': e.umur,
                'jenisKelamin': e.jenisKelamin,
              })
          .toList();

      await _ref.add({
        'idInvoice': data.idInvoice,
        'idTravel': data.idTravel,
        'emailUser': data.emailUser,
        'tanggalBerangkat': data.tanggalBerangkat,
        'listTraveler': travelerMap,
        'imageTransfer': data.imageTransfer,
        'category': data.category,
        'status': data.status,
      }).then((value) {
        response = 'Berhasil melakukan pembayaran';
        log(response);
      }).catchError((onError) {
        response = 'Gagal melakukan pembayaran';
        log('$response $onError');
      });

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ResTransaciton>> getListTransaction(
      {required String email}) async {
    try {
      QuerySnapshot result =
          await _ref.where('emailUser', isEqualTo: email).get();

      List<TransactionModel> listTransaction = result.docs
          .map(
              (e) => TransactionModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      log('LIST TRANSACTION $listTransaction');

      List<ResTransaciton> listRes = [];

      for (var element in listTransaction) {
        if (element.category == 'TRAVEL') {
          log('ID ${element.idTravel}');

          TravelModel travel =
              await TravelService().getListTravelById(id: element.idTravel);
          log('TRAVEL22 $travel');
          listRes.add(ResTransaciton(transaction: element, travel: travel));
        } else {
          WisataModel wisata =
              await WisataService().getListWisataById(id: element.idTravel);
          listRes.add(ResTransaciton(transaction: element, wisata: wisata));
        }
      }

      return listRes;
    } catch (e) {
      log('error $e');
      rethrow;
    }
  }
}
