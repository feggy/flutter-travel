import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/daftar_perjalanan/sukses_update_absen_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class AbsenPesertaPage extends StatefulWidget {
  final Absen absen;

  const AbsenPesertaPage({
    Key? key,
    required this.absen,
  }) : super(key: key);

  @override
  State<AbsenPesertaPage> createState() => _AbsenPesertaPageState();
}

class _AbsenPesertaPageState extends State<AbsenPesertaPage> {
  @override
  Widget build(BuildContext context) {
    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading...")),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
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

    return Scaffold(
        appBar: AppBarItem(title: 'Absen Peserta'),
        backgroundColor: whiteColor,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 10,
                ),
                child: Column(
                  children: widget.absen.listAbsenPeserta
                      .map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: grey2Color,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.nama,
                                      style:
                                          blackTextStyle.copyWith(fontSize: 12),
                                    ),
                                  ),
                                  Text(
                                    e.status ? 'Hadir' : 'Tidak hadir',
                                    style:
                                        primaryTextStyle.copyWith(fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: CupertinoSwitch(
                                        value: e.status,
                                        onChanged: (value) {
                                          setState(() {
                                            e.status = value;
                                          });
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            CustomButton(
              title: 'SIMPAN',
              margin: const EdgeInsets.all(20),
              onPressed: () {
                showAlertDialog('Simpan Absen',
                    'Pastikan absen telah diisi dengan benar, apakah Anda yakin menyimpan absen?',
                    () async {
                  showLoaderDialog(context);
                  await WisataService()
                      .updateAbsen(
                          idInvoice: widget.absen.idInvoice,
                          idWisata: widget.absen.idWisata,
                          pemandu: widget.absen.pemandu,
                          updated: widget.absen.updated,
                          listAbsen: widget.absen.listAbsenPeserta)
                      .then((value) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuksesUpdateAbsenPage(),
                      ),
                    );
                  });
                });
              },
            ),
          ],
        ));
  }
}
