// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class WisataModel extends Equatable {
  final String id;
  final String nama;
  final int biaya;
  final String deskripsiHari;
  final String imageUrl;
  List<HariModel> agenda;
  final String pemandu;
  List<dynamic> tanggalBerangkat;

  WisataModel({
    required this.id,
    required this.nama,
    required this.biaya,
    required this.deskripsiHari,
    required this.imageUrl,
    required this.agenda,
    required this.pemandu,
    required this.tanggalBerangkat,
  });

  factory WisataModel.fromJson(Map<String, dynamic> json) => WisataModel(
        id: json['id'],
        nama: json['nama'],
        biaya: json['biaya'],
        deskripsiHari: json['deskripsiHari'],
        imageUrl: json['imageUrl'],
        agenda: List.from(json['agenda'])
            .map((e) => HariModel.fromJson(e))
            .toList(),
        pemandu: json['pemandu'],
        tanggalBerangkat:
            List.from(json['tanggalBerangkat']).map((e) => e.toDate()).toList(),
      );

  @override
  List<Object?> get props => [
        id,
        nama,
        biaya,
        deskripsiHari,
        imageUrl,
        agenda.toList(),
        tanggalBerangkat.toList()
      ];

  @override
  String toString() {
    return 'WisataModel(id: $id, nama: $nama, biaya: $biaya, deskripsiHari: $deskripsiHari, imageUrl: $imageUrl, agenda: $agenda, pemandu: $pemandu, tanggalBerangkat: $tanggalBerangkat)';
  }
}

class HariModel extends Equatable {
  int dayOfNumber;
  List<AgendaModel> agenda;

  HariModel({required this.dayOfNumber, required this.agenda});

  factory HariModel.fromJson(Map<String, dynamic> json) => HariModel(
        dayOfNumber: json['dayOfNumber'],
        agenda: List.from(json['agenda'])
            .map((e) => AgendaModel.fromJson(e))
            .toList(),
      );

  @override
  List<Object?> get props => [dayOfNumber, agenda.toList()];

  @override
  String toString() {
    return '{dayOfNumber: "$dayOfNumber", agenda: "$agenda"}';
  }
}

class AgendaModel extends Equatable {
  int dayOfNumber;
  String startTime;
  String endTime;
  String deskripsi;

  AgendaModel({
    required this.dayOfNumber,
    required this.startTime,
    required this.endTime,
    required this.deskripsi,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) => AgendaModel(
        dayOfNumber: json['dayOfNumber'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        deskripsi: json['deskripsi'],
      );

  @override
  List<Object?> get props => [dayOfNumber, startTime, endTime, deskripsi];

  @override
  String toString() {
    return '{nama: "$dayOfNumber", startTime: "$startTime", endTime: "$endTime", deskripsi: "$deskripsi"}';
  }
}
