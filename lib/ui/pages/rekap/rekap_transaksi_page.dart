import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';

class RekapTransaksiPage extends StatelessWidget {
  const RekapTransaksiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Rekap Transaksi'),
      backgroundColor: whiteColor,
    );
  }
}
