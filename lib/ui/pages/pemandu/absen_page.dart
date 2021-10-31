import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/daftar_absen_page.dart';
import 'package:travel_wisata/ui/pages/pemandu/pilih_absen_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class AbsenPage extends StatelessWidget {
  final ResTransaciton? res;

  const AbsenPage({Key? key, required this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Absen>> getAbsen() async {
      return await WisataService().getAbsen(
          idInvoice: res!.transaction!.idInvoice,
          idWisata: res!.transaction!.idTravel,
          pemandu: res!.transaction!.jobFor);
    }

    return Scaffold(
      appBar: AppBarItem(title: 'QR Absen'),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: QrImage(
                      data: res!.transaction!.jobFor,
                      size: 250,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Scan QR untuk melakukan absen',
                    style: blackTextStyle.copyWith(fontWeight: medium),
                  ),
                )
              ],
            ),
          ),
          CustomButton(
            title: 'Daftar Absen'.toUpperCase(),
            margin: const EdgeInsets.all(20),
            onPressed: () async {
              await getAbsen().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        // DaftarAbsenPage(list: value.listAbsenPeserta),
                        PilihAbsenPage(
                      listAbsen: value,
                    ),
                  ),
                );
              }).catchError((onError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Peserta belum melakukan absen'),
                    backgroundColor: redColor,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
