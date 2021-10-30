// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/daftar_perjalanan/absen_peserta_page.dart';
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

    void permissionRequest() async {
      var req = await Permission.camera.request();
      if (req.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'Akses Kamera',
              style: blackTextStyle.copyWith(
                fontWeight: semiBold,
              ),
            ),
            content: Text(
              'Butuh akses kamera',
              style: blackTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Tolak',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Pengaturan',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }

    Future<String> startBarcodeStream() async {
      String barcodeScanRes;

      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.QR);
      } catch (e) {
        rethrow;
      }

      return barcodeScanRes;
    }

    Future<Absen> absenPeserta() async {
      List<AbsenPeserta> listAbsenPeserta = [];

      for (var element in res.transaction!.listTraveler) {
        listAbsenPeserta.add(AbsenPeserta(nama: element.nama));
      }

      return await WisataService().absenPeserta(
          data: Absen(
        idInvoice: res.transaction!.idInvoice,
        idWisata: res.transaction!.idTravel,
        pemandu: res.transaction!.jobFor,
        listAbsenPeserta: listAbsenPeserta,
        updated: DateTime.now(),
      ));
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
                  SingleTextCard(
                      text: 'Absen',
                      onPressed: () async {
                        var status = await Permission.camera.status;
                        if (status.isDenied) {
                          permissionRequest();
                        } else {
                          await startBarcodeStream().then((value) async {
                            String pemandu = res.transaction!.jobFor;
                            if (value != '-1') {
                              if (value == pemandu) {
                                await absenPeserta().then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AbsenPesertaPage(
                                        absen: value,
                                      ),
                                    ),
                                  );
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text('Format QR salah'),
                                      backgroundColor: redColor),
                                );
                              }
                            }
                          });
                        }
                      }),
                  const SizedBox(height: 10),
                  SingleTextCard(
                      text: 'Lihat posisi pemandu',
                      onPressed: () async {
                        await WisataService()
                            .getPemanduLokasi(
                                idWisata: res.transaction!.idTravel,
                                pemandu: res.transaction!.jobFor)
                            .then((value) {
                          launchUrl(value.lat, value.lng);
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
