import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var email = '';
  getPref() async {
    await SharedPreferences.getInstance().then((value) {
      email = value.getString('email') ?? '';
    });
    context
        .read<TransactionCubit>()
        .getListTransaction(email: email, page: 'riwayat');
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
                    'Riwayat Perjalanan',
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

                        return Model2Card(
                          nama: nama,
                          harga: harga,
                          deskripsi: '',
                          imageUrl: imageUrl,
                          status: status,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is TransactionFailed) {
            return NotFoundItem(text: 'Belum ada riwayat pesanan');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
