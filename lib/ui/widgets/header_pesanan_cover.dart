// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/shared/theme.dart';

class HeaderPesananCover extends StatelessWidget {
  final String title;
  final String price;
  final String desc;
  final String date;
  HeaderPesananCover({
    Key? key,
    required this.title,
    required this.price,
    required this.desc,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNumeric(String s) {
      return double.tryParse(s) != null;
    }

    String newSubtitle = "";
    if (isNumeric(price)) {
      int number = int.parse(price);
      newSubtitle = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(number);
    } else {
      newSubtitle = price;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: grey2Color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/ic_travel_date.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  date,
                  style:
                      greyTextStyle.copyWith(fontSize: 12, fontWeight: regular),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: medium,
              ),
            ),
            Text(
              newSubtitle,
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
            Text(
              desc,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
