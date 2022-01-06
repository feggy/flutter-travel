// ignore_for_file: must_be_immutable

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/cubit/gender_cubit.dart';
import 'package:travel_wisata/cubit/register_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:travel_wisata/ui/widgets/gender_item.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController birthController = TextEditingController(text: '');
  var gender = '';
  final TextEditingController phoneController = TextEditingController(text: '');
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController alamatController =
      TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GenderCubit>(context).reset();

    resetForm() {
      nameController.text = '';
      birthController.text = '';
      phoneController.text = '';
      emailController.text = '';
      alamatController.text = '';
      passwordController.text = '';
      gender = '';
      BlocProvider.of<GenderCubit>(context).reset();
    }

    Widget inputNama() {
      return CustomInputText(
        label: 'Nama',
        controller: nameController,
      );
    }

    Widget inputTanggalLahir() {
      final format = DateFormat("dd MMMM yyyy");
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: DateTimeField(
            format: format,
            style: blackTextStyle.copyWith(
              fontWeight: regular,
              fontSize: 14,
            ),
            controller: birthController,
            decoration: InputDecoration(
              label: Text(
                'Tanggal lahir',
                style: greyTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
            }),
      );
    }

    Widget inputGender() {
      return BlocBuilder<GenderCubit, String>(
        builder: (context, state) {
          gender = state;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kelamin',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
              Row(
                children: [
                  GenderItem(
                    gender: 'Laki-laki',
                    id: 'LK',
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GenderItem(
                    gender: 'Perempuan',
                    id: 'PR',
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    Widget inputPhone() {
      return CustomInputText(
        label: 'Nomor telepon',
        inputType: TextInputType.phone,
        controller: phoneController,
      );
    }

    Widget inputAlamat() {
      return CustomInputText(
        label: 'Alamat',
        controller: alamatController,
      );
    }

    Widget inputEmail() {
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

    Widget buttonRegister() {
      return BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: greenColor,
                content: const Text(
                  'Berhasil mendaftartkan akun, silahkan login',
                ),
              ),
            );
            resetForm();
          } else if (state is RegisterFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: redColor,
                content: Text(state.error),
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
              title: 'REGISTER',
              onPressed: () {
                var nama = nameController.text;
                var birth = birthController.text;
                var phone = phoneController.text;
                var email = emailController.text;
                var alamat = alamatController.text;
                var password = passwordController.text;

                String errorMsg = '';

                if (nama.isEmpty) {
                  errorMsg = 'Kolom nama tidak boleh kosong';
                } else if (birth.isEmpty) {
                  errorMsg = 'Kolom tanggal lahir tidak boleh kosong';
                } else if (phone.isEmpty) {
                  errorMsg = 'Kolom nomor hp tidak boleh kosong';
                } else if (email.isEmpty) {
                  errorMsg = 'Kolom email tidak boleh kosong';
                } else if (alamat.isEmpty) {
                  errorMsg = 'Kolom alamat tidak boleh kosong';
                } else if (password.isEmpty) {
                  errorMsg = 'Kolom password tidak boleh kosong';
                } else if (gender.isEmpty) {
                  errorMsg = 'Jenis kelamin belum dipilih';
                }

                if (errorMsg.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMsg),
                      backgroundColor: redColor,
                    ),
                  );
                } else {
                  context.read<RegisterCubit>().signUp(
                        email: emailController.text,
                        name: nameController.text,
                        password: passwordController.text,
                        role: 'USER',
                        birth: birthController.text,
                        gender: gender,
                        phone: phoneController.text,
                        address: alamatController.text,
                      );
                }
              });
        },
      );
    }

    Widget login() {
      return Column(
        children: [
          Center(
            child: Text(
              'Sudah memiliki akun?',
              style: blackTextStyle.copyWith(
                fontWeight: light,
                fontSize: 14,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              child: Text(
                'Login sekarang!',
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
        child: ListView(
          padding: EdgeInsets.only(
            left: kIsWeb ? MediaQuery.of(context).size.width / 3 : 20,
            right: kIsWeb ? MediaQuery.of(context).size.width / 3 : 20,
            bottom: 40,
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 40,
                bottom: 50,
              ),
              child: Text(
                'Register',
                style: blackTextStyle.copyWith(
                  fontWeight: semiBold,
                  fontSize: 34,
                ),
                textAlign: kIsWeb ? TextAlign.center : null,
              ),
            ),
            inputNama(),
            const SizedBox(
              height: 20,
            ),
            inputTanggalLahir(),
            const SizedBox(
              height: 20,
            ),
            inputGender(),
            const SizedBox(
              height: 20,
            ),
            inputPhone(),
            const SizedBox(
              height: 20,
            ),
            inputAlamat(),
            const SizedBox(
              height: 20,
            ),
            inputEmail(),
            const SizedBox(
              height: 20,
            ),
            inputPassword(),
            const SizedBox(
              height: 40,
            ),
            buttonRegister(),
            const SizedBox(
              height: 30,
            ),
            login(),
          ],
        ),
      ),
    );
  }
}
