// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

class HalamanKendaliSupirPage extends StatelessWidget {
  List<ResTransaciton> listRes;

  HalamanKendaliSupirPage({
    Key? key,
    required this.listRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget higlightWisata() {
      return Stack(
        children: [
          Model2Card(
              nama: listRes[0].travel!.nama,
              harga: listRes[0].travel!.kelas,
              deskripsi: '',
              imageUrl: listRes[0].travel!.imageUrl),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusDetailPage(
                          data: listRes[0].travel!, role: ROLE.supir),
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

    return Scaffold(
      appBar: AppBarItem(title: 'Halaman Kendali'),
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
              const SizedBox(height: 20),
              Text(
                'Daftar Penumpang',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: listRes
                    .map(
                      (e) => SingleTextCard(
                        text: e.transaction!.namaUser,
                        onPressed: () {},
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
