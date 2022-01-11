import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

import '../../../main.dart';

class LaporanTransaksiPage extends StatelessWidget {
  const LaporanTransaksiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Laporan Transaksi'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Row(
            children: [
              Expanded(child: SizedBox()),
              Container(
                width: 150,
                height: 30,
                alignment: Alignment.topRight,
                child: CustomButton(
                    title: 'Tambah Baru',
                    onPressed: () {
                      Navigator.pushNamed(
                          context, Routes.tambahLaporanTransaksiPage);
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
