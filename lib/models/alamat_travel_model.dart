// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:travel_wisata/models/transaction_model.dart';

class JemputPenumpang extends Equatable {
  String idTravel;
  String idInvoice;
  String lat;
  String lng;
  int status;
  String alamat;
  List<Traveler> listTraveler;
  String namaUser;
  String phoneUser;

  JemputPenumpang({
    required this.idTravel,
    required this.idInvoice,
    required this.lat,
    required this.lng,
    required this.status,
    required this.alamat,
    required this.listTraveler,
    required this.namaUser,
    required this.phoneUser,
  });

  Map<String, dynamic> toMap() {
    return {
      'idTravel': idTravel,
      'idInvoice': idInvoice,
      'lat': lat,
      'lng': lng,
      'status': status,
      'alamat': alamat,
      'listTraveler': listTraveler.map((x) => x.toMap()).toList(),
      'namaUser': namaUser,
      'phoneUser': phoneUser,
    };
  }

  factory JemputPenumpang.fromMap(Map<String, dynamic> map) {
    return JemputPenumpang(
      idTravel: map['idTravel'],
      idInvoice: map['idInvoice'],
      lat: map['lat'],
      lng: map['lng'],
      status: map['status'],
      alamat: map['alamat'],
      listTraveler: List<Traveler>.from(
          map['listTraveler']?.map((x) => Traveler.fromMap(x))),
      namaUser: map['namaUser'],
      phoneUser: map['phoneUser'],
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
      lat,
      lng,
      status,
      alamat,
      listTraveler,
      namaUser,
      phoneUser,
    ];
  }

  @override
  bool get stringify => true;

  JemputPenumpang copyWith({
    String? idTravel,
    String? idInvoice,
    String? idUser,
    String? lat,
    String? lng,
    int? status,
    String? alamat,
    List<Traveler>? listTraveler,
    String? namaUser,
    String? phoneUser,
  }) {
    return JemputPenumpang(
      idTravel: idTravel ?? this.idTravel,
      idInvoice: idInvoice ?? this.idInvoice,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      alamat: alamat ?? this.alamat,
      listTraveler: listTraveler ?? this.listTraveler,
      namaUser: namaUser ?? this.namaUser,
      phoneUser: phoneUser ?? this.phoneUser,
    );
  }
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
