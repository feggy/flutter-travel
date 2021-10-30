import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/shared/theme.dart';
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
              onPressed: () {},
            ),
          ],
        ));
  }
}
