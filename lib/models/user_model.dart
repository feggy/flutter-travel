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
    required this.id,
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
  List<Object?> get props =>
      [id, email, name, password, role, birth, gender, phone, address];
}
