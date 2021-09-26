// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class BankItem extends StatelessWidget {
  final String image;
  final String noRek;
  final String nameRek;

  BankItem(
      {Key? key,
      required this.image,
      required this.noRek,
      required this.nameRek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 22,
            width: 70,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '$noRek a/n $nameRek',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }
}
