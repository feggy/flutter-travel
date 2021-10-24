// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/wisata_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';
import 'package:url_launcher/url_launcher.dart';

class KendaliPerjalananPage extends StatelessWidget {
  final String category;
  ResTransaciton res;

  KendaliPerjalananPage({
    Key? key,
    required this.category,
    required this.res,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget higlightWisata() {
      return Stack(
        children: [
          Model2Card(
              nama: res.wisata!.nama,
              harga: res.wisata!.deskripsiHari,
              deskripsi: '',
              imageUrl: res.wisata!.imageUrl),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WisataDetailPage(
                        data: res.wisata!,
                        role: ROLE.user,
                        res: res,
                      ),
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

    void launchUrl(String latitude, String longitude) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      await canLaunch(googleUrl)
          ? await launch(googleUrl)
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SizedBox(),
              ),
            );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Menu Perjalanan'),
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
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Kendali',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleTextCard(text: 'Absen', onPressed: () {}),
                  const SizedBox(height: 10),
                  SingleTextCard(
                      text: 'Lihat posisi pemandu',
                      onPressed: () async {
                        await WisataService()
                            .getPemanduLokasi(
                                idWisata: res.transaction!.idTravel,
                                pemandu: res.transaction!.jobFor)
                            .then((value) {
                          // log('_ $value');
                          // launchUrl(value.lat, value.lng);
                        }).catchError((onError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Terjadi kesalahan $onError'),
                            ),
                          );
                        });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
