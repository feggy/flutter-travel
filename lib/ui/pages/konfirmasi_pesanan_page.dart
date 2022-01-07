import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/header_pesanan_cover.dart';

class KonfirmasiPesananPage extends StatelessWidget {
  const KonfirmasiPesananPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    var transaction = arguments['transaction'] as TransactionModel?;
    var dataTravel = arguments['dataTravel'] as TravelModel?;
    var dataWisata = arguments['dataWisata'] as WisataModel?;

    var listTraveler = transaction!.listTraveler;
    var tglBerangkat = transaction.tanggalBerangkat;

    log('transaction $transaction\ndata travel $dataTravel\ndata wisata $dataWisata');

    var title = '';
    var price = '';
    var desc = '';

    if (dataWisata != null) {
      title = dataWisata.nama;
      price = dataWisata.biaya.toString();
      desc = dataWisata.deskripsiHari;
    } else {
      title = dataTravel!.nama;
      price = dataTravel.biaya.toString();
      desc = dataTravel.kelas;
    }

    int number = int.parse(price);
    var priceRp = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(number);

    int total = int.parse(price) * listTraveler.length;
    var totalRp = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(total);

    Widget headerBox() {
      return HeaderPesananCover(
        title: title,
        price: priceRp,
        desc: desc,
        date: DateFormat("dd MMMM yyyy").format(tglBerangkat),
      );
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
              title: 'KONFIRMASI',
              onPressed: () {
                Navigator.pushNamed(context, '/pembayaran', arguments: {
                  'transaction': transaction,
                });
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
            '${listTraveler.length} x Traveler x $priceRp',
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
            totalRp,
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
