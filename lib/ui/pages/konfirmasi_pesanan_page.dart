import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/header_pesanan_cover.dart';

class KonfirmasiPesananPage extends StatelessWidget {
  const KonfirmasiPesananPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget headerBox() {
      return HeaderPesananCover(
          title: 'Wisata Bukit Tinggi',
          price: 'Rp2.000.000',
          desc: '3 Hari 2 Malam',
          date: '18 September 2021');
    }

    Widget buttonLanjut() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 30,
          ),
          child: CustomButton(
              title: 'PEMBAYARAN',
              onPressed: () {
                Navigator.pushNamed(context, '/pembayaran');
              }),
        ),
      );
    }

    Widget detailPembayaran() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Pembayaran',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Subtotal',
            style: greyTextStyle.copyWith(
              fontSize: 12,
              fontWeight: regular,
            ),
          ),
          Text(
            '10 Traveler x Rp2.000.000',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Total Harga',
            style: greyTextStyle.copyWith(
              fontSize: 12,
              fontWeight: regular,
            ),
          ),
          Text(
            'Rp20.000.000',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Konfirmasi Pesanan'),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerBox(),
                  detailPembayaran(),
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
