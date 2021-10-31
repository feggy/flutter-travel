import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/models/absen_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/daftar_absen_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

class PilihAbsenPage extends StatelessWidget {
  final List<Absen> listAbsen;

  const PilihAbsenPage({Key? key, required this.listAbsen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Piilh Absen'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: listAbsen
            .map(
              (e) => SingleTextCard(
                text: DateFormat('kk:mm - dd MMMM yyyy').format(e.updated),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DaftarAbsenPage(list: e.listAbsenPeserta),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
