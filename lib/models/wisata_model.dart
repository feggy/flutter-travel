// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class WisataModel extends Equatable {
  final String id;
  final String nama;
  final String biaya;
  final String deskripsiHari;
  final String imageUrl;
  List<HariModel> agenda;

  WisataModel({
    required this.id,
    required this.nama,
    required this.biaya,
    required this.deskripsiHari,
    required this.imageUrl,
    required this.agenda,
  });

  var mapAgenda = {};

  factory WisataModel.fromJson(Map<String, dynamic> json) => WisataModel(
        id: json['id'],
        nama: json['nama'],
        biaya: json['biaya'],
        deskripsiHari: json['deskripsiHari'],
        imageUrl: json['imageUrl'],
        agenda: List.from(json['agenda'])
            .map((e) => HariModel.fromJson(e))
            .toList(),
      );

  @override
  List<Object?> get props =>
      [id, nama, biaya, deskripsiHari, imageUrl, agenda.toList()];

  @override
  String toString() {
    return '{id: "$id", nama: "$nama", biaya: "$biaya", deskripsiHari: "$deskripsiHari", imageUrl: "$imageUrl", agenda: "$agenda"}';
  }
}

class HariModel extends Equatable {
  final int dayOfNumber;
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
  final int dayOfNumber;
  final String startTime;
  final String endTime;
  final String deskripsi;

  const AgendaModel({
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
