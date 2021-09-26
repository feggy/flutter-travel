// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class TravelerCard extends StatelessWidget {
  final String nama;
  TravelerCard({Key? key, required this.nama}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: grey2Color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/ic_person.png',
              width: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                nama,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
            ),
            Image.asset(
              'assets/ic_enter.png',
              width: 15,
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
