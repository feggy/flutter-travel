import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/hari_agenda_item.dart';
import 'package:url_launcher/url_launcher.dart';

import 'isi_data_wisata_page.dart';

class WisataDetailPage extends StatefulWidget {
  final WisataModel data;
  final ROLE role;
  const WisataDetailPage({
    Key? key,
    required this.data,
    required this.role,
  }) : super(key: key);

  @override
  State<WisataDetailPage> createState() => _WisataDetailPageState();
}

class _WisataDetailPageState extends State<WisataDetailPage> {
  var tglBerangkat = 'Pilih tanggal';

  @override
  Widget build(BuildContext context) {
    Widget coverHeader() {
      return Image.network(
        widget.data.imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }

    Widget titleRating() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.data.nama,
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 45,
            height: 25,
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/ic_star.png',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '4.0',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    bool isNumeric(String s) {
      return double.tryParse(s) != null;
    }

    String newSubtitle = "";
    if (isNumeric(widget.data.biaya)) {
      int number = int.parse(widget.data.biaya);
      newSubtitle = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(number);
    } else {
      newSubtitle = widget.data.biaya;
    }

    Widget deskripsiPrice() {
      return Row(
        children: [
          Expanded(
            child: Text(
              widget.data.deskripsiHari,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: regular,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            newSubtitle,
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: medium,
            ),
          ),
        ],
      );
    }

    Widget agenda() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agenda Perjalanan',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.data.agenda.isNotEmpty)
            Column(
                children: widget.data.agenda
                    .map(
                      (e) => HariAgendaItem(data: e),
                    )
                    .toList())
          else
            Center(
              child: Text(
                'Belum ada agenda yang ditambahkan',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            ),
        ],
      );
    }

    Widget inputDate() {
      DateFormat formatter = DateFormat('dd MMM yyyy');

      bool _decideWhichDayToEnable(DateTime day) {
        if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
            day.isBefore(DateTime.now().add(const Duration(days: 90))))) {
          return true;
        }
        return false;
      }

      return GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2022),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            selectableDayPredicate: _decideWhichDayToEnable,
          ).then((value) {
            setState(() {
              tglBerangkat = formatter.format(value!);
              log(tglBerangkat);
            });
          });
        },
        child: Container(
            width: 100,
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tglBerangkat,
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: regular,
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: blackColor,
                ),
              ],
            )),
      );
    }

    Widget tanggalBerangkat() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Tanggal keberangakatan',
              style:
                  blackTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/ic_jam.png',
                  width: 20,
                  height: 20,
                ),
                inputDate(),
              ],
            ),
          )
        ],
      );
    }

    Widget footerPesan() {
      return Padding(
        padding: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          top: 10,
          bottom: 30,
        ),
        child: Column(
          children: [
            tanggalBerangkat(),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
                title: 'PESAN SEKARANG',
                onPressed: () {
                  if (tglBerangkat == "Pilih tanggal") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Pilih tanggal keberangkatn terlebih dahulu'),
                        backgroundColor: redColor,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPendaftaranPage(
                          category: 'WISATA',
                          tglBerangkat: tglBerangkat,
                          dataWisata: widget.data,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
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

    void startBarcodeStream() async {
      FlutterBarcodeScanner.getBarcodeStreamReceiver(
              '#ff6666', 'Batal', false, ScanMode.BARCODE)!
          .listen((event) {
        log(event);
      });
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

    Widget footerPesertaWisata() {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              title: 'ABSEN',
              onPressed: () async {
                var status = await Permission.camera.status;
                if (status.isDenied) {
                  permissionRequest();
                } else {
                  startBarcodeStream();
                }
              },
              width: (MediaQuery.of(context).size.width / 2.2) - 50,
            ),
            CustomButton(
              title: 'CARI PEMANDU',
              onPressed: () {
                launchUrl('0.466052', '101.3560171');
              },
              width: (MediaQuery.of(context).size.width / 2.2) - 50,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    coverHeader(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: horizontalMargin,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleRating(),
                          const SizedBox(
                            height: 5,
                          ),
                          deskripsiPrice(),
                          const SizedBox(
                            height: 25,
                          ),
                          agenda()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            widget.role == ROLE.user
                ? footerPesan()
                // footerPesertaWisata(),
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
