// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class LokasiModel extends Equatable {
  String pemandu;
  String idWisata;
  String lat;
  String lng;
  DateTime timeCreated;
  LokasiModel({
    required this.pemandu,
    required this.idWisata,
    required this.lat,
    required this.lng,
    required this.timeCreated,
  });

  LokasiModel copyWith({
    String? pemandu,
    String? idWisata,
    String? lat,
    String? lng,
    DateTime? timeCreated,
  }) {
    return LokasiModel(
      pemandu: pemandu ?? this.pemandu,
      idWisata: idWisata ?? this.idWisata,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pemandu': pemandu,
      'idWisata': idWisata,
      'lat': lat,
      'lng': lng,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
    };
  }

  factory LokasiModel.fromMap(Map<String, dynamic> map) {
    return LokasiModel(
      pemandu: map['pemandu'],
      idWisata: map['idWisata'],
      lat: map['lat'],
      lng: map['lng'],
      timeCreated: map['timeCreated'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LokasiModel.fromJson(String source) =>
      LokasiModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      pemandu,
      idWisata,
      lat,
      lng,
      timeCreated,
    ];
  }
}
