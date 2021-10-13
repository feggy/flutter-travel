import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var role = '';
  getRole() async {
    final pref = await SharedPreferences.getInstance();
    role = pref.getString('role') ?? '';
  }

  @override
  void initState() {
    getRole();
    Timer(const Duration(seconds: 3), () {
      //NOTE READ cek current user ke firebase authentication
      User? user = FirebaseAuth.instance.currentUser;
      if (role.isNotEmpty && user != null) {
        context.read<AuthCubit>().getCurrentUser(user.uid);
        if (role == 'USER') {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        } else if (role == 'ADMIN') {
          Navigator.pushNamedAndRemoveUntil(
              context, '/admin', (route) => false);
        } else if (role == 'PEMANDU') {
          Navigator.pushNamedAndRemoveUntil(
              context, '/pemandu_home', (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}
