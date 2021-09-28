// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';

/*NOTE 
* Status 
* 0 Menunggu persetujuan, 1 disetujui, 2 sedang berlangsung, 3 ditolak, 4 selesai
*/

class TransactionModel extends Equatable {
  final String idInvoice;
  final String idTravel;
  final String emailUser;
  final String tanggalBerangkat;
  final List<Traveler> listTraveler;
  String imageTransfer;
  final String category;
  int status;
  String namaUser;
  String phoneUser;
  String timeCreated;

  TransactionModel({
    required this.idInvoice,
    required this.idTravel,
    required this.emailUser,
    required this.tanggalBerangkat,
    required this.listTraveler,
    required this.imageTransfer,
    required this.category,
    required this.status,
    required this.namaUser,
    required this.phoneUser,
    required this.timeCreated,
  });

  @override
  List<Object> get props {
    return [
      idInvoice,
      idTravel,
      emailUser,
      tanggalBerangkat,
      listTraveler,
      imageTransfer,
      category,
      status,
      namaUser,
      phoneUser,
      timeCreated,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'idInvoice': idInvoice,
      'idTravel': idTravel,
      'emailUser': emailUser,
      'tanggalBerangkat': tanggalBerangkat,
      'listTraveler': listTraveler.map((x) => x.toMap()).toList(),
      'imageTransfer': imageTransfer,
      'category': category,
      'status': status,
      'namaUser': namaUser,
      'phoneUser': phoneUser,
      'timeCreated': timeCreated,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      idInvoice: map['idInvoice'],
      idTravel: map['idTravel'],
      emailUser: map['emailUser'],
      tanggalBerangkat: map['tanggalBerangkat'],
      listTraveler: List<Traveler>.from(
          map['listTraveler']?.map((x) => Traveler.fromMap(x))),
      imageTransfer: map['imageTransfer'],
      category: map['category'],
      status: map['status'],
      namaUser: map['namaUser'],
      phoneUser: map['phoneUser'],
      timeCreated: map['timeCreated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}

class Traveler {
  final String nama;
  final String umur;
  final String jenisKelamin;

  Traveler({
    required this.nama,
    required this.umur,
    required this.jenisKelamin,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'umur': umur,
      'jenisKelamin': jenisKelamin,
    };
  }

  factory Traveler.fromMap(Map<String, dynamic> map) {
    return Traveler(
      nama: map['nama'],
      umur: map['umur'],
      jenisKelamin: map['jenisKelamin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Traveler.fromJson(String source) =>
      Traveler.fromMap(json.decode(source));

  @override
  String toString() =>
      'Travel(nama: $nama, umur: $umur, jenisKelamin: $jenisKelamin)';
}

class ResTransaciton {
  TransactionModel? transaction;
  TravelModel? travel;
  WisataModel? wisata;
  ResTransaciton({
    this.transaction,
    this.travel,
    this.wisata,
  });

  @override
  String toString() =>
      'ResTransaciton(transaction: $transaction, travel: $travel, wisata: $wisata)';
}
