import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/shared/theme.dart';

enum Category {
  wisata,
  travel,
}

class Model2Card extends StatelessWidget {
  final String nama;
  final String harga;
  final String deskripsi;
  final String imageUrl;

  const Model2Card({
    Key? key,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNumeric(String s) {
      return double.tryParse(s) != null;
    }

    String newSubtitle = "";
    if (isNumeric(harga)) {
      int number = int.parse(harga);
      newSubtitle = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp',
        decimalDigits: 0,
      ).format(number);
    } else {
      newSubtitle = harga;
    }

    Widget loadImage() {
      return imageUrl.isNotEmpty
          ? Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: grey2Color,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: grey2Color,
                image: const DecorationImage(
                  image: AssetImage('assets/logo.png'),
                ),
              ),
            );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          loadImage(),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  overflow: TextOverflow.ellipsis,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  newSubtitle,
                  overflow: TextOverflow.ellipsis,
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  deskripsi,
                  overflow: TextOverflow.ellipsis,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
