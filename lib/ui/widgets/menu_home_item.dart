import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class MenuHomeItem extends StatelessWidget {
  final String image;
  final String title;
  final Function() onPressed;

  const MenuHomeItem(
      {Key? key,
      required this.image,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 50,
            height: 50,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: blackTextStyle.copyWith(fontSize: 11, fontWeight: light),
          ),
        ],
      ),
    );
  }
}
