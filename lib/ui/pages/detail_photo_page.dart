import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:travel_wisata/shared/theme.dart';

class DetailPhotoPage extends StatelessWidget {
  final String imageUrl;
  const DetailPhotoPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: transparentColor,
            title: Text(
              'Bukti transfer',
              style: whiteTextStyle.copyWith(
                fontSize: 24,
                fontWeight: semiBold,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: whiteColor,
              ),
            ),
          ),
          Expanded(
            child: Hero(
              tag: 'transfer',
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
