import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String password;
  final String role;
  final String birth;
  final String gender;
  final String phone;
  final String address;

  const UserModel({
    this.id = "",
    required this.email,
    required this.name,
    required this.password,
    required this.role,
    required this.birth,
    required this.gender,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
        id: id,
        name: json['name'],
        email: json['email'],
        password: json['password'],
        phone: json['phone'],
        role: json['role'],
        address: json['address'],
        birth: json['birth'],
        gender: json['gender'],
      );

  @override
  List<Object> get props {
    return [
      id,
      email,
      name,
      password,
      role,
      birth,
      gender,
      phone,
      address,
    ];
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    String? role,
    String? birth,
    String? gender,
    String? phone,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
      birth: birth ?? this.birth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'role': role,
      'birth': birth,
      'gender': gender,
      'phone': phone,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      password: map['password'],
      role: map['role'],
      birth: map['birth'],
      gender: map['gender'],
      phone: map['phone'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
