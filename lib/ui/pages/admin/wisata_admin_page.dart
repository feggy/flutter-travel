import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/wisata_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/wisata_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class WisataAdminPage extends StatefulWidget {
  const WisataAdminPage({Key? key}) : super(key: key);

  @override
  State<WisataAdminPage> createState() => _WisataAdminPageState();
}

class _WisataAdminPageState extends State<WisataAdminPage> {
  @override
  void initState() {
    super.initState();
    context.read<WisataCubit>().getListWisata();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonTambah() {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
        ),
        child: CustomButton(
          title: 'TAMBAH',
          onPressed: () {
            Navigator.pushNamed(context, '/tambah_wisata')
                .then((value) => context.read<WisataCubit>().getListWisata());
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Wisata'),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<WisataCubit, WisataState>(
              builder: (context, state) {
                log('message $state');
                if (state is WisataSuccess) {
                  return ListView(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    children: state.data
                        .map((e) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WisataDetailPage(
                                            data: e,
                                            role: ROLE.admin,
                                          )),
                                );
                              },
                              child: Model2Card(
                                nama: e.nama,
                                harga: e.biaya,
                                deskripsi: e.deskripsiHari,
                                imageUrl: e.imageUrl,
                              ),
                            ))
                        .toList(),
                  );
                } else if (state is WisataFailed) {
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
