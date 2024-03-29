import 'dart:convert';

import 'package:equatable/equatable.dart';

class TravelModel extends Equatable {
  final String id;
  final String nama;
  final int biaya;
  final String kelas;
  final String spesifikasi;
  final String fasilitas;
  final String imageUrl;
  final String supir;

  const TravelModel({
    required this.id,
    required this.nama,
    required this.biaya,
    required this.kelas,
    required this.spesifikasi,
    required this.fasilitas,
    required this.imageUrl,
    required this.supir,
  });

  @override
  List<Object?> get props =>
      [id, nama, biaya, kelas, spesifikasi, fasilitas, imageUrl];

  @override
  String toString() {
    return '{$id, $nama, $biaya, $kelas, $spesifikasi, $fasilitas, $imageUrl}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'biaya': biaya,
      'kelas': kelas,
      'spesifikasi': spesifikasi,
      'fasilitas': fasilitas,
      'imageUrl': imageUrl,
      'supir': supir,
    };
  }

  factory TravelModel.fromMap(Map<String, dynamic> map) {
    return TravelModel(
      id: map['id'],
      nama: map['nama'],
      biaya: map['biaya'],
      kelas: map['kelas'],
      spesifikasi: map['spesifikasi'],
      fasilitas: map['fasilitas'],
      imageUrl: map['imageUrl'],
      supir: map['supir'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TravelModel.fromJson(String source) =>
      TravelModel.fromMap(json.decode(source));
}
