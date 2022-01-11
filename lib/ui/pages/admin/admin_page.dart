import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/daftar_pelanggan_page.dart';
import 'package:travel_wisata/ui/pages/laporan_transaksi/laporan_transaksi_page.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

import '../../../main.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget listCard() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kIsWeb ? MediaQuery.of(context).size.width / 5 : 0,
        ),
        child: Column(
          children: [
            SingleTextCard(
              text: 'Daftar Transaksi',
              onPressed: () {
                Navigator.pushNamed(context, '/transaksi_admin');
              },
            ),
            SingleTextCard(
              text: 'Kelola Daftar Wisata',
              onPressed: () {
                Navigator.pushNamed(context, '/wisata_admin');
              },
            ),
            SingleTextCard(
              text: 'Kelola Daftar Travel',
              onPressed: () {
                Navigator.pushNamed(context, '/bus_admin');
              },
            ),
            SingleTextCard(
              text: 'Daftar Pemandu Wisata',
              onPressed: () {
                Navigator.pushNamed(context, '/pemandu');
              },
            ),
            SingleTextCard(
              text: 'Daftar Pelanggan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const DaftarPelangganPage(),
                  ),
                );
              },
            ),
            // SingleTextCard(
            //   text: 'Kelola Supir',
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/supir');
            //   },
            // ),
            SingleTextCard(
              text: 'Laporan Transaksi',
              onPressed: () {
                Navigator.pushNamed(context, Routes.laporanTransaksiPage);
              },
            ),
            SingleTextCard(
              text: 'Ubah Profil',
              onPressed: () {
                Navigator.pushNamed(context, '/ubah_profil');
              },
            ),
          ],
        ),
      );
    }

    void removePref() async {
      final pref = await SharedPreferences.getInstance();
      pref.clear();
    }

    Widget logout() {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          } else if (state is AuthFailed) {
            log('ERROR ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: redColor,
            ));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const CircularProgressIndicator();
          }
          return CustomButton(
            title: 'LOGOUT',
            onPressed: () {
              removePref();
              context.read<AuthCubit>().logout();
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Beranda Admin',
                              style: blackTextStyle.copyWith(
                                fontSize: 24,
                                fontWeight: semiBold,
                              ),
                            ),
                          ),
                          kIsWeb
                              ? SizedBox(
                                  width: 80,
                                  height: 25,
                                  child: logout(),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      listCard(),
                    ],
                  ),
                ),
              ),
              !kIsWeb ? logout() : const SizedBox(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
