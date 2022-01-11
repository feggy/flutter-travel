// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:travel_wisata/shared/theme.dart';

class CustomInputText extends StatelessWidget {
  final String label;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final TextInputAction imeOption;
  final bool readOnly;
  List<TextInputFormatter>? inputFormatters;

  CustomInputText({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.inputType = TextInputType.name,
    required this.controller,
    this.imeOption = TextInputAction.next,
    this.readOnly = false,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextFormField(
        cursorColor: Colors.black,
        obscureText: obscureText,
        keyboardType: inputType,
        textInputAction: imeOption,
        style: blackTextStyle.copyWith(
          fontWeight: regular,
          fontSize: 14,
        ),
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          label: Text(
            label,
            style: greyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        readOnly: readOnly,
        enabled: readOnly ? false : null,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
