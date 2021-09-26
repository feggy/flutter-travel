// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_wisata/cubit/register_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TambahPemanduPage extends StatelessWidget {
  final String role;

  TambahPemanduPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  final TextEditingController namaController = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController phoneController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    log('ROLE $role');
    Widget buttonSimpan() {
      return BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pop(context);
          } else if (state is RegisterFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: redColor,
                content: Text(state.error.split(']')[1]),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomButton(
              title: 'SIMPAN',
              onPressed: () {
                if (namaController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: redColor,
                      content: const Text(
                        'Gagal! Semua kolom harus di isi',
                      ),
                    ),
                  );
                } else {
                  context.read<RegisterCubit>().signUp(
                        name: namaController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        phone: phoneController.text,
                        role: role,
                        address: '',
                        birth: '',
                        gender: '',
                      );
                }
              });
        },
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Tambah ${role.toLowerCase()}'),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  CustomInputText(
                    label: 'Nama',
                    controller: namaController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Nomor Hp',
                    inputType: TextInputType.number,
                    controller: phoneController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Email',
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Password',
                    controller: passwordController,
                    imeOption: TextInputAction.done,
                    obscureText: true,
                  ),
                ],
              ),
            ),
            buttonSimpan(),
          ],
        ),
      ),
    );
  }
}
