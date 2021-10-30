// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class Absen extends Equatable {
  String idInvoice;
  String idWisata;
  String pemandu;
  List<AbsenPeserta> listAbsenPeserta;
  DateTime updated;
  Absen({
    required this.idInvoice,
    required this.idWisata,
    required this.pemandu,
    required this.listAbsenPeserta,
    required this.updated,
  });

  Absen copyWith({
    String? idInvoice,
    String? idWisata,
    String? pemandu,
    List<AbsenPeserta>? listAbsenPeserta,
    DateTime? updated,
  }) {
    return Absen(
      idInvoice: idInvoice ?? this.idInvoice,
      idWisata: idWisata ?? this.idWisata,
      pemandu: pemandu ?? this.pemandu,
      listAbsenPeserta: listAbsenPeserta ?? this.listAbsenPeserta,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idInvoice': idInvoice,
      'idWisata': idWisata,
      'pemandu': pemandu,
      'listAbsenPeserta': listAbsenPeserta.map((x) => x.toMap()).toList(),
      'updated': updated.millisecondsSinceEpoch,
    };
  }

  factory Absen.fromMap(Map<String, dynamic> map) {
    return Absen(
      idInvoice: map['idInvoice'],
      idWisata: map['idWisata'],
      pemandu: map['pemandu'],
      listAbsenPeserta: List<AbsenPeserta>.from(
          map['listAbsenPeserta']?.map((x) => AbsenPeserta.fromMap(x))),
      updated: map['updated'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Absen.fromJson(String source) => Absen.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      idInvoice,
      idWisata,
      pemandu,
      listAbsenPeserta,
      updated,
    ];
  }
}

class AbsenPeserta extends Equatable {
  String nama;
  bool status;
  AbsenPeserta({
    required this.nama,
    this.status = false,
  });

  @override
  String toString() => 'Absen(nama: $nama, status: $status)';

  AbsenPeserta copyWith({
    String? nama,
    bool? status,
  }) {
    return AbsenPeserta(
      nama: nama ?? this.nama,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'status': status,
    };
  }

  factory AbsenPeserta.fromMap(Map<String, dynamic> map) {
    return AbsenPeserta(
      nama: map['nama'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AbsenPeserta.fromJson(String source) =>
      AbsenPeserta.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [nama, status];
}
