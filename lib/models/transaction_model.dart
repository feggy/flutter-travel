import 'dart:convert';

import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String idInvoice;
  final String idTravel;
  final String jumlah;
  final String tanggalBerangkat;
  final List<Traveler> listTravel;
  final String imageTransfer;
  final String category;

  const TransactionModel({
    required this.idInvoice,
    required this.idTravel,
    required this.jumlah,
    required this.tanggalBerangkat,
    required this.listTravel,
    required this.imageTransfer,
    required this.category,
  });

  @override
  List<Object?> get props => [
        idInvoice,
        idTravel,
        jumlah,
        tanggalBerangkat,
        listTravel,
        imageTransfer,
        category,
      ];

  Map<String, dynamic> toMap() {
    return {
      'idInvoice': idInvoice,
      'idTravel': idTravel,
      'jumlah': jumlah,
      'tanggalBerangkat': tanggalBerangkat,
      'listTravel': listTravel.map((x) => x.toMap()).toList(),
      'imageTransfer': imageTransfer,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      idInvoice: map['idInvoice'],
      idTravel: map['idTravel'],
      jumlah: map['jumlah'],
      tanggalBerangkat: map['tanggalBerangkat'],
      listTravel: List<Traveler>.from(
          map['listTravel']?.map((x) => Traveler.fromMap(x))),
      imageTransfer: map['imageTransfer'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) =>
      TransactionModel.fromMap(json.decode(source));
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
