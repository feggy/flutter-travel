// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/cubit/wisata_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/pages/wisata_detail_page.dart';
import 'package:travel_wisata/ui/widgets/menu_home_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/rekomendasi_wisata_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<WisataCubit>().getListWisata();
    context.read<TravelCubit>().getListTravel();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mau Kemana?',
              style:
                  blackTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
            ),
            Text(
              'Jalan-jalan yuk!',
              style: greyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
          ],
        ),
      );
    }

    Widget menu() {
      return Padding(
        padding: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          bottom: 30,
          top: 40,
        ),
        child: Row(
          children: [
            MenuHomeItem(
              image: 'assets/logo_wisata.png',
              title: 'Wisata',
              onPressed: () {
                Navigator.pushNamed(context, '/wisata');
              },
            ),
            SizedBox(
              width: 20,
            ),
            MenuHomeItem(
              image: 'assets/logo_bus.png',
              title: 'Travel',
              onPressed: () {
                Navigator.pushNamed(context, '/bus');
              },
            ),
          ],
        ),
      );
    }

    Widget rekomendasiWisata() {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wisata seru untukmu',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<WisataCubit, WisataState>(
              builder: (context, state) {
                if (state is WisataSuccess) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.data
                          .map((e) => GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WisataDetailPage(
                                        data: e,
                                        role: ROLE.user,
                                      ),
                                    ),
                                  );
                                },
                                child: RekomendasiWisataItem(
                                  nama: e.nama,
                                  desc: e.deskripsiHari,
                                  image: e.imageUrl,
                                ),
                              ))
                          .toList(),
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget rekomendasiTiketBus() {
      return Padding(
        padding: const EdgeInsets.only(
          top: 30,
          left: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesan mudah tiket travel sekarang',
              style: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: semiBold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<TravelCubit, TravelState>(
              builder: (context, state) {
                if (state is TravelSuccess) {
                  return SingleChildScrollView(
                    child: Column(
                        children: state.travel
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BusDetailPage(
                                          data: e,
                                          role: ROLE.user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Model2Card(
                                    nama: e.nama,
                                    harga: e.biaya,
                                    deskripsi: e.kelas,
                                    imageUrl: e.imageUrl,
                                  ),
                                ))
                            .toList()),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        children: [
          header(),
          menu(),
          rekomendasiWisata(),
          rekomendasiTiketBus(),
        ],
      ),
    );
  }
}
