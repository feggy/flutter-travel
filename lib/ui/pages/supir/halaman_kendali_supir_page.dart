// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/pages/supir/detail_penumpang_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HalamanKendaliSupirPage extends StatelessWidget {
  List<ResTransaciton> listRes;

  HalamanKendaliSupirPage({
    Key? key,
    required this.listRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget higlightWisata() {
      return Stack(
        children: [
          Model2Card(
              nama: listRes[0].travel!.nama,
              harga:
                  'Tanggal berangkat: ${listRes[0].transaction!.tanggalBerangkat}',
              deskripsi: '',
              imageUrl: listRes[0].travel!.imageUrl),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusDetailPage(
                          data: listRes[0].travel!, role: ROLE.supir),
                    ));
              },
              child: Text(
                'Lihat Detail',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      );
    }

    showAlertDialog(
      String title,
      String desc,
      Function()? onPressed,
    ) {
      Widget cancelButton = TextButton(
        child: const Text("Tidak"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      Widget continueButton = TextButton(
        child: const Text("Ya"),
        onPressed: onPressed,
      );

      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Widget mulaiTravel() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/sukses_travel', (route) => false);
          } else if (state is TransactionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoadingAdd) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleTextCard(
              text: 'Mulai perjalanan',
              onPressed: () {
                showAlertDialog(
                    'Mulai perjalanan', 'Apakah Anda yakin memulai perjalanan?',
                    () {
                  Navigator.pop(context);
                  context.read<TransactionCubit>().updateStatus(
                      status: 2,
                      category: 'TRAVEL',
                      idTravel: listRes[0].travel!.id,
                      tanggalBerangkat:
                          listRes[0].transaction!.tanggalBerangkat);
                });
              });
        },
      );
    }

    Widget akhiriTravel() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/akhiri_travel', (route) => false);
          } else if (state is TransactionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoadingAdd) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleTextCard(
              text: 'Akhiri perjalanan',
              onPressed: () {
                showAlertDialog('Akhiri perjalanan',
                    'Apakah Anda yakin mengakhiri perjalanan?', () {
                  Navigator.pop(context);
                  context.read<TransactionCubit>().updateStatus(
                      status: 4,
                      category: 'TRAVEL',
                      idTravel: listRes[0].travel!.id,
                      tanggalBerangkat:
                          listRes[0].transaction!.tanggalBerangkat);
                });
              });
        },
      );
    }

    Widget statusTravel() {
      if (listRes[0].transaction!.status == 1) {
        return mulaiTravel();
      } else if (listRes[0].transaction!.status == 2) {
        return akhiriTravel();
      } else {
        return Text(
          'Perjalanan ini telah berakhir',
          style: blackTextStyle.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        );
      }
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Halaman Kendali'),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              higlightWisata(),
              const SizedBox(height: 20),
              Text(
                'Menu Kendali',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 10),
              statusTravel(),
              const SizedBox(height: 10),
              Text(
                'Daftar Pemesan',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: listRes
                    .map(
                      (e) => SingleTextCard(
                        text:
                            '${e.transaction!.namaUser} - ${e.transaction!.listTraveler.length} tiket',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPenumpangPage(res: e),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
