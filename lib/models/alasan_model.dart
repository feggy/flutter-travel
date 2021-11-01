import 'dart:convert';

import 'package:equatable/equatable.dart';

class AlasanModel extends Equatable {
  String idInvoice;
  String idTravel;
  String pemandu;
  String alasan;
  DateTime timeCreated;

  AlasanModel({
    required this.idInvoice,
    required this.idTravel,
    required this.pemandu,
    required this.alasan,
    required this.timeCreated,
  });

  AlasanModel copyWith({
    String? idInvoice,
    String? idTravel,
    String? pemandu,
    String? alasan,
    DateTime? timeCreated,
  }) {
    return AlasanModel(
      idInvoice: idInvoice ?? this.idInvoice,
      idTravel: idTravel ?? this.idTravel,
      pemandu: pemandu ?? this.pemandu,
      alasan: alasan ?? this.alasan,
      timeCreated: timeCreated ?? this.timeCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idInvoice': idInvoice,
      'idTravel': idTravel,
      'pemandu': pemandu,
      'alasan': alasan,
      'timeCreated': timeCreated.millisecondsSinceEpoch,
    };
  }

  factory AlasanModel.fromMap(Map<String, dynamic> map) {
    return AlasanModel(
      idInvoice: map['idInvoice'],
      idTravel: map['idTravel'],
      pemandu: map['pemandu'],
      alasan: map['alasan'],
      timeCreated: map['timeCreated'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AlasanModel.fromJson(String source) =>
      AlasanModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      idInvoice,
      idTravel,
      pemandu,
      alasan,
      timeCreated,
    ];
  }
}
