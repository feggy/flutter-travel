// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/data_traveler_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/header_pesanan_cover.dart';
import 'package:travel_wisata/ui/widgets/traveler_card.dart';

class FormPendaftaranPage extends StatefulWidget {
  final String category;
  final String tglBerangkat;
  TravelModel? dataTravel;
  WisataModel? dataWisata;

  FormPendaftaranPage({
    Key? key,
    required this.category,
    required this.tglBerangkat,
    this.dataTravel,
    this.dataWisata,
  }) : super(key: key);

  @override
  State<FormPendaftaranPage> createState() => _FormPendaftaranPageState();
}

class _FormPendaftaranPageState extends State<FormPendaftaranPage> {
  List<Traveler> listTraveler = [];

  @override
  Widget build(BuildContext context) {
    Widget tambahPeserta() {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/data_traveler').then((value) {
            Traveler data = value as Traveler;
            log(data.toString());
            setState(() {
              listTraveler.add(data);
            });
          });
        },
        child: Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: grey2Color,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/ic_person.png',
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'Tambah Traveler*',
                    style: blackTextStyle.copyWith(
                      fontSize: 12,
                      fontWeight: regular,
                      color: redColor,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/ic_enter.png',
                  width: 15,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget headerBox() {
      return HeaderPesananCover(
          title: widget.dataWisata != null
              ? widget.dataWisata!.nama
              : widget.dataTravel!.nama,
          price: widget.dataWisata != null
              ? widget.dataWisata!.biaya
              : widget.dataTravel!.biaya,
          desc: widget.dataWisata != null
              ? widget.dataWisata!.deskripsiHari
              : widget.dataTravel!.kelas,
          date: widget.tglBerangkat);
    }

    Widget detailTraveler() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail Traveler',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          Column(
            children: listTraveler
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataTravelerPage(
                            data: e,
                          ),
                        ),
                      ).then((value) {
                        var result = value as Traveler;
                        log(result.toString());
                        var index = listTraveler.indexOf(e);
                        setState(() {
                          listTraveler.removeAt(index);
                          listTraveler.add(result);
                        });
                      });
                    },
                    child: TravelerCard(nama: e.nama),
                  ),
                )
                .toList(),
          ),
          tambahPeserta(),
        ],
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
              title: 'LANJUTKAN',
              onPressed: () {
                if (listTraveler.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Silahkan tambahkan data traveler terlebih dahulu'),
                      backgroundColor: redColor,
                    ),
                  );
                }
                // Navigator.pushNamed(context, '/konfirmasi_pesanan');
              }),
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Isi Data'),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    headerBox(),
                    detailTraveler(),
                  ],
                ),
              ),
            ),
            buttonLanjut(),
          ],
        ),
      ),
    );
  }
}
