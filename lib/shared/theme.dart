import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double horizontalMargin = 20.0;
double statusBarHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top.toDouble();
}

Color primaryColor = const Color(0xff4D9DD6);
Color blackColor = const Color(0xff565656);
Color greyColor = const Color(0xffA0A0A0);
Color grey2Color = const Color(0xffF4F4F4);
Color grey3Color = const Color(0xffE5E5E5);
Color whiteColor = const Color(0xffFFFFFF);
Color greenColor = const Color(0xff4DD673);
Color redColor = const Color(0xffD64D4D);
Color transparentColor = Colors.transparent;

TextStyle blackTextStyle = GoogleFonts.poppins(color: blackColor);
TextStyle greyTextStyle = GoogleFonts.poppins(color: greyColor);
TextStyle primaryTextStyle = GoogleFonts.poppins(color: primaryColor);
TextStyle whiteTextStyle = GoogleFonts.poppins(color: whiteColor);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
