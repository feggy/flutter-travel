// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:travel_wisata/cubit/gender_cubit.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:travel_wisata/ui/widgets/gender_item.dart';

class DataTravelerPage extends StatelessWidget {
  Traveler? data;

  DataTravelerPage({
    Key? key,
    this.data,
  }) : super(key: key);

  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController umurController = TextEditingController(text: '');
  String gender = '';

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GenderCubit>(context).reset();

    if (data != null) {
      nameController.text = data!.nama;
      umurController.text = data!.umur;
      context.read<GenderCubit>().selected(data!.jenisKelamin);
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

    Widget buttonLanjut() {
      return CustomButton(
          title: 'LANJUTKAN',
          onPressed: () {
            var nama = nameController.text;
            var umur = umurController.text;
            String errorMsg = '';

            if (nama.isEmpty) {
              errorMsg = 'Kolom nama tidak boleh kosong';
            } else if (umur.isEmpty) {
              errorMsg = 'Kolom umur tidak boleh kosong';
            } else if (gender.isEmpty) {
              errorMsg = 'Harap isi jenis kelamin terlebeih dahulu';
            }

            if (errorMsg.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMsg),
                  backgroundColor: redColor,
                ),
              );
            } else {
              Navigator.pop(context,
                  Traveler(nama: nama, umur: umur, jenisKelamin: gender));
            }
          });
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Data Traveler'),
      body: Padding(
        padding: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          top: 40,
          bottom: 30,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomInputText(
                    label: 'Nama',
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Umur',
                    inputType: TextInputType.number,
                    controller: umurController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputGender(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            buttonLanjut(),
          ],
        ),
      ),
    );
  }
}
