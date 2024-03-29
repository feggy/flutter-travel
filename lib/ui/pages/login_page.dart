import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

import '../../main.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget header(String text) {
      return Container(
        margin: const EdgeInsets.only(
          top: 40,
          bottom: 80,
        ),
        child: Text(
          text,
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

    setPref(
      String role,
      String email,
      String phone,
      String name,
    ) async {
      final pref = await SharedPreferences.getInstance();
      pref.setString('role', role);
      pref.setString('email', email);
      pref.setString('phone', phone);
      pref.setString('name', name);
    }

    Widget buttonLogin() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setPref(
              state.user.role,
              state.user.email,
              state.user.phone,
              state.user.name,
            );
            if (state.user.role == 'USER') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/main', (route) => false);
            } else if (state.user.role == 'ADMIN') {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.admin, (route) => false);
            } else if (state.user.role == 'PEMANDU') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/pemandu_home', (route) => false);
            } else if (state.user.role == 'SUPIR') {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/supir_home', (route) => false);
            }
          } else if (state is AuthFailed) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Login Gagal'),
                content: const Text('Email atau password salah!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'))
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
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
              'Belum memiliki akun?',
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

    Widget contentMobile() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header('Login'),
            inputUsername(),
            const SizedBox(
              height: 20,
            ),
            inputPassword(),
            const SizedBox(
              height: 30,
            ),
            buttonLogin(),
            const SizedBox(
              height: 65,
            ),
            register(),
          ],
        ),
      );
    }

    Widget contentWeb() {
      return Center(
        child: Container(
          width: 350,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              header('MAVICK'),
              const SizedBox(height: 50),
              inputUsername(),
              const SizedBox(
                height: 20,
              ),
              inputPassword(),
              const SizedBox(
                height: 30,
              ),
              buttonLogin(),
              // const SizedBox(height: 30),
              // register(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: kIsWeb ? contentWeb() : contentMobile(),
        ),
      ),
    );
  }
}
