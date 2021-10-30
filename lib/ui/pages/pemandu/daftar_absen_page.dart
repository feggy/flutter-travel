import 'package:flutter/material.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';

class DaftarAbsenPage extends StatelessWidget {
  final List<AbsenPeserta>? list;

  const DaftarAbsenPage({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Absen'),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            children: list != null
                ? list!
                    .map((e) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: grey2Color,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.nama,
                                    style:
                                        blackTextStyle.copyWith(fontSize: 12),
                                  ),
                                ),
                                Text(
                                  e.status ? 'Hadir' : 'Tidak hadir',
                                  style:
                                      primaryTextStyle.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList()
                : []),
      ),
    );
  }
}
