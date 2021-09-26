// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class NotFoundItem extends StatelessWidget {
  final String text;
  NotFoundItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/data_not_found.png'),
            width: 220,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            text,
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
