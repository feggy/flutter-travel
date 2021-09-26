import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class RekomendasiWisataItem extends StatelessWidget {
  final String nama;
  final String desc;
  final String image;

  const RekomendasiWisataItem({
    Key? key,
    required this.nama,
    required this.desc,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider loadImage() {
      if (image.isNotEmpty) {
        return NetworkImage(image);
      } else {
        return AssetImage(image);
      }
    }

    return Container(
      width: 120,
      height: 150,
      margin: const EdgeInsets.only(
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: grey2Color,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: DecorationImage(
                image: loadImage(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            nama,
            overflow: TextOverflow.ellipsis,
            style: blackTextStyle.copyWith(
              fontSize: 10,
              fontWeight: regular,
            ),
          ),
          Text(
            desc,
            overflow: TextOverflow.ellipsis,
            style: blackTextStyle.copyWith(
              fontSize: 10,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }
}
