import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/pages/daftar_perjalanan/kendali_perjalan.dart';
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
    context
        .read<TransactionCubit>()
        .getListTransaction(email: email, page: 'berlangsung');
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
                        var harga =
                            'Tanggal berangkat ${DateFormat("dd MMM yyyy").format(e.transaction!.tanggalBerangkat)}';
                        var imageUrl = '';
                        var status = e.transaction!.status;

                        if (e.transaction!.category == 'TRAVEL') {
                          nama = e.travel!.nama;
                          imageUrl = e.travel!.imageUrl;
                        } else {
                          nama = e.wisata!.nama;
                          imageUrl = e.wisata!.imageUrl;
                        }

                        if (status == 2) {
                          return InkWell(
                            onTap: () {
                              if (e.transaction!.category == 'TRAVEL') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BusDetailPage(
                                      data: e.travel!,
                                      role: ROLE.user,
                                      res: e,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KendaliPerjalananPage(
                                      category: 'WISATA',
                                      res: e,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Model2Card(
                              nama: nama,
                              harga: harga,
                              deskripsi: '',
                              imageUrl: imageUrl,
                              status: status,
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
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
