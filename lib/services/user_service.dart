// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
      var birth = DateTime.now();

      try {
        birth = snapshot['birth'].toDate();
      } catch (e) {
        log('_ $e');
      }

      return UserModel(
        id: id,
        email: snapshot['email'],
        name: snapshot['name'],
        password: snapshot['password'],
        role: snapshot['role'],
        birth: birth,
        gender: snapshot['gender'],
        phone: snapshot['phone'],
        address: snapshot['address'],
      );
    } catch (e) {
      log('_ $e');
      rethrow;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      UserModel? user;

      await _userReference.where('email', isEqualTo: email).get().then((value) {
        user = value.docs
            .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
            .toList()[0];
      }).catchError((onError) {
        log('ERROR $onError');
      });

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> editUser({
    required email,
    required name,
    required birth,
    required gender,
    required phone,
    required address,
  }) async {
    try {
      bool status = false;
      var result = await _userReference.where('email', isEqualTo: email).get();

      if (result.docs.isNotEmpty) {
        for (var element in result.docs) {
          var id = element.id;
          await _userReference.doc(id).update({
            'name': name,
            'birth': birth,
            'gender': gender,
            'phone': phone,
            'address': address,
          }).then((value) {
            status = true;
          }).catchError((onError) {
            log('_ $onError');
            status = false;
          });
        }
      }
      return status;
    } catch (onError) {
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
