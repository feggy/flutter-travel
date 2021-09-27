// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(
          top: 40,
          bottom: 80,
        ),
        child: Text(
          'Login',
          style: blackTextStyle.copyWith(
            fontSize: 34,
            fontWeight: semiBold,
          ),
        ),
      );
    }

    Widget inputUsername() {
      return CustomInputText(
        label: 'Email',
        inputType: TextInputType.emailAddress,
        controller: emailController,
      );
    }

    Widget inputPassword() {
      return CustomInputText(
        label: 'Password',
        obscureText: true,
        controller: passwordController,
        imeOption: TextInputAction.done,
      );
    }

    setPref(String role, String email) async {
      final pref = await SharedPreferences.getInstance();
      pref.setString('role', role);
      pref.setString('email', email);
    }

    Widget buttonLogin() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setPref(state.user.role, state.user.email);
            if (state.user.role == 'USER') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/main', (route) => false);
            } else if (state.user.role == 'ADMIN') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/admin', (route) => false);
            }
          } else if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: redColor,
                content: Text('Login Gagal!\nEmail atau password salah!'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomButton(
            title: 'LOGIN',
            onPressed: () {
              context.read<AuthCubit>().signIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
            },
          );
        },
      );
    }

    Widget register() {
      return Column(
        children: [
          Center(
            child: Text(
              'Tidak memiliki akun?',
              style: blackTextStyle.copyWith(
                fontWeight: light,
                fontSize: 14,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                emailController.text = '';
                passwordController.text = '';
                Navigator.pushNamed(context, '/register');
              },
              child: Text(
                'Daftar disini!',
                style: blackTextStyle.copyWith(
                  fontWeight: light,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                inputUsername(),
                const SizedBox(
                  height: 20,
                ),
                inputPassword(),
                const SizedBox(
                  height: 30,
                ),
                buttonLogin(),
                SizedBox(
                  height: 65,
                ),
                register(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
