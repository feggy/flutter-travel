import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class AppBarItem extends StatelessWidget with PreferredSizeWidget {
  final String title;
  AppBarItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      title: Text(
        title,
        style: blackTextStyle.copyWith(
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
          color: blackColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
