import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class TransactionAdminPage extends StatefulWidget {
  const TransactionAdminPage({Key? key}) : super(key: key);

  @override
  State<TransactionAdminPage> createState() => _TransactionAdminPageState();
}

class _TransactionAdminPageState extends State<TransactionAdminPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().getListTransaction(email: 'admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Transaksi'),
      backgroundColor: whiteColor,
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          log('message $state');
          if (state is TransactionSuccess) {
            return ListView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
              ),
              children: state.list.map((e) {
                var nama = '';
                var harga =
                    'Tanggal berangkat ${e.transaction!.tanggalBerangkat}';
                var imageUrl = '';
                var status = e.transaction!.status;

                if (e.transaction!.category == 'TRAVEL') {
                  nama = e.travel!.nama;
                  imageUrl = e.travel!.imageUrl;
                } else {
                  nama = e.wisata!.nama;
                  imageUrl = e.wisata!.imageUrl;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail_transaksi_admin',
                      arguments: {'res': e},
                    ).then((value) => context
                        .read<TransactionCubit>()
                        .getListTransaction(email: 'admin'));
                  },
                  child: Model2Card(
                    nama: nama,
                    harga: harga,
                    deskripsi: '',
                    imageUrl: imageUrl,
                    status: status,
                  ),
                );
              }).toList(),
            );
          } else if (state is TransactionFailed) {
            return NotFoundItem(text: 'Belum ada transaksi');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
