import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class BusAdminPage extends StatefulWidget {
  const BusAdminPage({Key? key}) : super(key: key);

  @override
  State<BusAdminPage> createState() => _BusAdminPageState();
}

class _BusAdminPageState extends State<BusAdminPage> {
  @override
  void initState() {
    super.initState();
    context.read<TravelCubit>().getListTravel();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonTambah() {
      return CustomButton(
        title: 'TAMBAH',
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_bus');
        },
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
        ),
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Travel'),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TravelCubit, TravelState>(
              builder: (context, state) {
                log('state $state');
                if (state is TravelSuccess) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                          children: state.travel
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BusDetailPage(
                                                  data: e,
                                                  role: ROLE.admin,
                                                )),
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
                    ),
                  );
                } else if (state is TravelError) {
                  return NotFoundItem(text: state.error);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          buttonTambah(),
        ],
      ),
    );
  }
}
