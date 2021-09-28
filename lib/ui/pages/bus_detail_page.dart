import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/isi_data_wisata_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class BusDetailPage extends StatefulWidget {
  final TravelModel data;
  final ResTransaciton? res;
  final ROLE role;

  const BusDetailPage({
    Key? key,
    required this.data,
    required this.role,
    this.res,
  }) : super(key: key);

  @override
  State<BusDetailPage> createState() => _BusDetailPageState();
}

class _BusDetailPageState extends State<BusDetailPage> {
  var tglBerangkat = 'Pilih tanggal';

  @override
  Widget build(BuildContext context) {
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

    ImageProvider loadImage() {
      if (widget.data.imageUrl.isNotEmpty) {
        return NetworkImage(widget.data.imageUrl);
      } else {
        return const AssetImage('assets/logo.png');
      }
    }

    Widget header() {
      return Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: loadImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.nama,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  newSubtitle,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.data.kelas,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget spesifikasi() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spesifikasi Armada',
            style: blackTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.data.spesifikasi,
            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: regular),
          ),
        ],
      );
    }

    Widget fasilitas() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fasilitas',
            style: blackTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.data.fasilitas,
            style: blackTextStyle.copyWith(fontSize: 12, fontWeight: regular),
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

    Widget footerUser() {
      if (widget.res != null) {
        return const SizedBox();
      } else {
        return Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 30,
            left: 20,
            right: 20,
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
                            category: 'TRAVEL',
                            tglBerangkat: tglBerangkat,
                            dataTravel: widget.data,
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        );
      }
    }

    Widget footerAdmin() {
      return CustomButton(
          title: 'UBAH',
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 30,
          ),
          onPressed: () {});
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Rincian'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    const SizedBox(
                      height: 30,
                    ),
                    spesifikasi(),
                    const SizedBox(
                      height: 20,
                    ),
                    fasilitas(),
                  ],
                ),
              ),
            ),
          ),
          widget.role == ROLE.user ? footerUser() : footerAdmin(),
        ],
      ),
    );
  }
}
