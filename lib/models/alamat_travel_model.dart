// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class JemputPenumpang extends Equatable {
  String idTravel;
  String idInvoice;
  String idUser;
  String lat;
  String lng;
  int status;
  String alamat;

  JemputPenumpang({
    required this.idTravel,
    required this.idInvoice,
    required this.idUser,
    required this.lat,
    required this.lng,
    required this.status,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return {
      'idTravel': idTravel,
      'idInvoice': idInvoice,
      'idUser': idUser,
      'lat': lat,
      'lng': lng,
      'status': status,
      'alamat': alamat,
    };
  }

  factory JemputPenumpang.fromMap(Map<String, dynamic> map) {
    return JemputPenumpang(
      idTravel: map['idTravel'],
      idInvoice: map['idInvoice'],
      idUser: map['idUser'],
      lat: map['lat'],
      lng: map['lng'],
      status: map['status'],
      alamat: map['alamat'],
    );
  }

  String toJson() => json.encode(toMap());

  factory JemputPenumpang.fromJson(String source) =>
      JemputPenumpang.fromMap(json.decode(source));

  @override
  List<Object> get props {
    return [
      idTravel,
      idInvoice,
      idUser,
      lat,
      lng,
      status,
      alamat,
    ];
  }

  @override
  bool get stringify => true;
}

class AlamatKoordinat {
  String? jalan;
  String? kecamatan;
  String? kelurahan;
  String? kabupaten;
  String? provinsi;
  String? postalCode;
  AlamatKoordinat({
    required this.jalan,
    required this.kecamatan,
    required this.kelurahan,
    required this.kabupaten,
    required this.provinsi,
    required this.postalCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'jalan': jalan,
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'postalCode': postalCode,
    };
  }

  factory AlamatKoordinat.fromMap(Map<String, dynamic> map) {
    return AlamatKoordinat(
      jalan: map['jalan'],
      kecamatan: map['kecamatan'],
      kelurahan: map['kelurahan'],
      kabupaten: map['kabupaten'],
      provinsi: map['provinsi'],
      postalCode: map['postalCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AlamatKoordinat.fromJson(String source) =>
      AlamatKoordinat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AlamatKoordinat(jalan: $jalan, kecamatan: $kecamatan, kelurahan: $kelurahan, kabupaten: $kabupaten, provinsi: $provinsi, postalCode: $postalCode)';
  }
}
