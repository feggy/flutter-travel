import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class AppBarItem extends StatelessWidget with PreferredSizeWidget {
  final String title;
  AppBarItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      elevation: 0,
      title: Text(
        title,
        style: blackTextStyle.copyWith(
          fontSize: 24,
          fontWeight: semiBold,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 15,
          color: blackColor,
        ),
        splashRadius: 15,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
