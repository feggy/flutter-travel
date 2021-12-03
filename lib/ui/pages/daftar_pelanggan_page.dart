import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/user_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

class DaftarPelangganPage extends StatefulWidget {
  const DaftarPelangganPage({Key? key}) : super(key: key);

  @override
  State<DaftarPelangganPage> createState() => _DaftarPelangganPageState();
}

class _DaftarPelangganPageState extends State<DaftarPelangganPage> {
  List<UserModel> listUser = [];

  void getUser() async {
    await UserService().getListUser('USER').then((value) {
      setState(() {
        listUser = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Pelanggan'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
        ),
        children: listUser
            .map(
              (e) => SingleTextCard(
                text: e.name,
                onPressed: () {},
                noIcon: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
