import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  var email = '';
  getPref() async {
    await SharedPreferences.getInstance().then((value) {
      email = value.getString('email') ?? '';
    });
    context.read<TransactionCubit>().getListTransaction(email: email);
  }

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().reset();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          log(state.toString());
          if (state is TransactionSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 40,
                  ),
                  child: Text(
                    'Daftar Perjalanan',
                    style: blackTextStyle.copyWith(
                      fontSize: 24,
                      fontWeight: semiBold,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 50,
                    ),
                    child: Column(
                      children: state.list.map((e) {
                        var nama = '';
                        var harga = '';
                        var deskripsi = '';
                        var imageUrl = '';

                        if (e.transaction!.category == 'TRAVEL') {
                          nama = e.travel!.nama;
                          harga =
                              'Tanggal berangkat ${e.transaction!.tanggalBerangkat}';
                          if (e.transaction!.status == 0) {
                            deskripsi = 'Menuggu persetujuan';
                          } else if (e.transaction!.status == 1) {
                            deskripsi = 'Disetujui';
                          }
                          imageUrl = e.travel!.imageUrl;
                        }

                        return Model2Card(
                            nama: nama,
                            harga: harga,
                            deskripsi: deskripsi,
                            imageUrl: imageUrl);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is TransactionFailed) {
            return NotFoundItem(text: 'Belum ada agenda sedang\nberlangsung');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
