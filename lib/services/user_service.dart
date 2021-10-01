// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_wisata/models/user_model.dart';

class UserService {
  //NOTE Collection users pada database firebase, class ini akan menambahkan data ke sana
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  //NOTE CREATE user ke fireabse database
  Future<void> setUser(UserModel user) async {
    try {
      _userReference.doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'password': user.password,
        'role': user.role,
        'birth': user.birth,
        'gender': user.gender,
        'phone': user.phone,
        'address': user.address,
      });
    } catch (e) {
      rethrow;
    }
  }

  // NOTE READ data users dengan melakukan get by id
  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      return UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        password: snapshot['password'],
        role: snapshot['role'],
        birth: snapshot['birth'],
        gender: snapshot['gender'],
        phone: snapshot['phone'],
        address: snapshot['address'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getListUser(String role) async {
    try {
      List<UserModel> listUser = [];

      await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: role)
          .get()
          .then((value) {
        listUser =
            value.docs.map((e) => UserModel.fromJson(e.id, e.data())).toList();
      }).catchError((onError) => log('ERROR get list pemandu $onError'));

      return listUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserAvailable(String email, String role) async {
    try {
      var result = await _userReference
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: role)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }).catchError((onError) => log('ERROR checkUserAvailable $onError'));

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
