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
        'namaUser': data.namaUser,
        'phoneUser': data.phoneUser,
        'timeCreated': data.timeCreated,
        'jobFor': data.jobFor,
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
      {required String email, String? page}) async {
    try {
      QuerySnapshot result =
          await _ref.where('emailUser', isEqualTo: email).get();

      if (email == 'admin') {
        result = await _ref.get();
      }

      if (page == 'riwayat') {
        result = await _ref.where('emailUser', isEqualTo: email).get();
      } else if (page == 'berlangsung') {
        result = await _ref
            .where('emailUser', isEqualTo: email)
            .where('status', isEqualTo: 2)
            .get();
      }

      List<TransactionModel> listTransaction = result.docs
          .map(
              (e) => TransactionModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      List<ResTransaciton> listRes = [];

      if (page == 'riwayat') {
        for (var element in listTransaction) {
          if (element.status != 2) {
            if (element.category == 'TRAVEL') {
              TravelModel travel =
                  await TravelService().getListTravelById(id: element.idTravel);
              listRes.add(ResTransaciton(transaction: element, travel: travel));
            } else {
              WisataModel wisata =
                  await WisataService().getListWisataById(id: element.idTravel);
              listRes.add(ResTransaciton(transaction: element, wisata: wisata));
            }
          }
        }
      } else {
        for (var element in listTransaction) {
          if (element.category == 'TRAVEL') {
            TravelModel travel =
                await TravelService().getListTravelById(id: element.idTravel);
            listRes.add(ResTransaciton(transaction: element, travel: travel));
          } else {
            WisataModel wisata =
                await WisataService().getListWisataById(id: element.idTravel);
            listRes.add(ResTransaciton(transaction: element, wisata: wisata));
          }
        }
      }

      return listRes;
    } catch (e) {
      log('error $e');
      rethrow;
    }
  }

  Future<List<ResTransaciton>> getListJob({required String email}) async {
    try {
      QuerySnapshot result = await _ref.where('jobFor', isEqualTo: email).get();

      List<TransactionModel> listTransaction = result.docs
          .map(
              (e) => TransactionModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      List<ResTransaciton> listRes = [];

      for (var element in listTransaction) {
        if (element.category == 'TRAVEL') {
          TravelModel travel =
              await TravelService().getListTravelById(id: element.idTravel);
          listRes.add(ResTransaciton(transaction: element, travel: travel));
        } else {
          WisataModel wisata =
              await WisataService().getListWisataById(id: element.idTravel);
          listRes.add(ResTransaciton(transaction: element, wisata: wisata));
        }
      }

      return listRes;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResTransaciton> getTransaction({required String idInvoice}) async {
    try {
      var result = await _ref.where('idInvoice', isEqualTo: idInvoice).get();

      var dataTransaction = result.docs
          .map(
              (e) => TransactionModel.fromMap(e.data() as Map<String, dynamic>))
          .toList()[0];

      if (dataTransaction.category == 'TRAVEL') {
        TravelModel travel = await TravelService()
            .getListTravelById(id: dataTransaction.idTravel);
        return ResTransaciton(transaction: dataTransaction, travel: travel);
      } else {
        WisataModel wisata = await WisataService()
            .getListWisataById(id: dataTransaction.idTravel);
        return ResTransaciton(transaction: dataTransaction, wisata: wisata);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateStatus(
      {required String idInvoice, required int status}) async {
    try {
      var result = await _ref.where('idInvoice', isEqualTo: idInvoice).get();
      String response = '';

      if (result.docs.isNotEmpty) {
        for (var element in result.docs) {
          var id = element.id;
          await _ref.doc(id).update({'status': status}).then((value) {
            response = 'Status pembayaran berhasil disetujui';
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
}
