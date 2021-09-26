import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onPressed;
  final EdgeInsets margin;
  final Color color;
  final TextStyle? textStyle;
  final double height;

  const CustomButton({
    Key? key,
    required this.title,
    this.width = double.infinity,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.color = const Color(0xff4D9DD6),
    this.textStyle,
    this.height = 45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: color,
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Text(
                title,
                style: textStyle ??
                    whiteTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: semiBold,
                      color: whiteColor,
                    ),
              ),
            ),
          )),
    );
  }
}
