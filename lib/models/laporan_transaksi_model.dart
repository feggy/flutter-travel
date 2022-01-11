import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LaporanTransaksiModel {
  String id;
  String idTravel;
  String kategori;
  String nama;
  Timestamp bulan;
  int totalPemasukkan;
  int totalPengeluaran;
  int banyakPeserta;
  int biayaPaket;
  List<Pengeluaran> listPengeluaran;
  Timestamp timeCreated;
  LaporanTransaksiModel({
    required this.id,
    required this.idTravel,
    required this.kategori,
    required this.nama,
    required this.bulan,
    required this.totalPemasukkan,
    required this.totalPengeluaran,
    required this.banyakPeserta,
    required this.biayaPaket,
    required this.listPengeluaran,
    required this.timeCreated,
  });

  LaporanTransaksiModel copyWith({
    String? id,
    String? idTravel,
    String? kategori,
    String? nama,
    Timestamp? bulan,
    int? totalPemasukkan,
    int? totalPengeluaran,
    int? banyakPeserta,
    int? biayaPaket,
    List<Pengeluaran>? listPengeluaran,
    Timestamp? timeCreated,
  }) {
    return LaporanTransaksiModel(
      id: id ?? this.id,
      idTravel: idTravel ?? this.idTravel,
      kategori: kategori ?? this.kategori,
      nama: nama ?? this.nama,
      bulan: bulan ?? this.bulan,
      totalPemasukkan: totalPemasukkan ?? this.totalPemasukkan,
      totalPengeluaran: totalPengeluaran ?? this.totalPengeluaran,
      banyakPeserta: banyakPeserta ?? this.banyakPeserta,
      biayaPaket: biayaPaket ?? this.biayaPaket,
      listPengeluaran: listPengeluaran ?? this.listPengeluaran,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idTravel': idTravel,
      'kategori': kategori,
      'nama': nama,
      'bulan': bulan,
      'totalPemasukkan': totalPemasukkan,
      'totalPengeluaran': totalPengeluaran,
      'banyakPeserta': banyakPeserta,
      'biayaPaket': biayaPaket,
      'listPengeluaran': listPengeluaran.map((x) => x.toMap()).toList(),
      'timeCreated': timeCreated,
    };
  }

  factory LaporanTransaksiModel.fromMap(Map<String, dynamic> map) {
    return LaporanTransaksiModel(
      id: map['id'] ?? '',
      idTravel: map['idTravel'] ?? '',
      kategori: map['kategori'] ?? '',
      nama: map['nama'] ?? '',
      bulan: map['bulan'],
      totalPemasukkan: map['totalPemasukkan']?.toInt() ?? 0,
      totalPengeluaran: map['totalPengeluaran']?.toInt() ?? 0,
      banyakPeserta: map['banyakPeserta']?.toInt() ?? 0,
      biayaPaket: map['biayaPaket']?.toInt() ?? 0,
      listPengeluaran: List<Pengeluaran>.from(
          map['listPengeluaran']?.map((x) => Pengeluaran.fromMap(x))),
      timeCreated: map['timeCreated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LaporanTransaksiModel.fromJson(String source) =>
      LaporanTransaksiModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LaporanTransaksiModel(id: $id, idTravel: $idTravel, kategori: $kategori, nama: $nama, bulan: $bulan, totalPemasukkan: $totalPemasukkan, totalPengeluaran: $totalPengeluaran, banyakPeserta: $banyakPeserta, biayaPaket: $biayaPaket, listPengeluaran: $listPengeluaran, timeCreated: $timeCreated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LaporanTransaksiModel &&
        other.id == id &&
        other.idTravel == idTravel &&
        other.kategori == kategori &&
        other.nama == nama &&
        other.bulan == bulan &&
        other.totalPemasukkan == totalPemasukkan &&
        other.totalPengeluaran == totalPengeluaran &&
        other.banyakPeserta == banyakPeserta &&
        other.biayaPaket == biayaPaket &&
        listEquals(other.listPengeluaran, listPengeluaran) &&
        other.timeCreated == timeCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idTravel.hashCode ^
        kategori.hashCode ^
        nama.hashCode ^
        bulan.hashCode ^
        totalPemasukkan.hashCode ^
        totalPengeluaran.hashCode ^
        banyakPeserta.hashCode ^
        biayaPaket.hashCode ^
        listPengeluaran.hashCode ^
        timeCreated.hashCode;
  }
}

class Pengeluaran {
  String id;
  String nama;
  int qty;
  int biaya;
  Pengeluaran({
    required this.id,
    required this.nama,
    required this.qty,
    required this.biaya,
  });

  Pengeluaran copyWith({
    String? id,
    String? nama,
    int? qty,
    int? biaya,
  }) {
    return Pengeluaran(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      qty: qty ?? this.qty,
      biaya: biaya ?? this.biaya,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'qty': qty,
      'biaya': biaya,
    };
  }

  factory Pengeluaran.fromMap(Map<String, dynamic> map) {
    return Pengeluaran(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      qty: map['qty']?.toInt() ?? 0,
      biaya: map['biaya']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pengeluaran.fromJson(String source) =>
      Pengeluaran.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Pengeluaran(id: $id, nama: $nama, qty: $qty, biaya: $biaya)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pengeluaran &&
        other.id == id &&
        other.nama == nama &&
        other.qty == qty &&
        other.biaya == biaya;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nama.hashCode ^ qty.hashCode ^ biaya.hashCode;
  }
}
