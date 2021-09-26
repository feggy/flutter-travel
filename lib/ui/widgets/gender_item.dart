// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:travel_wisata/cubit/gender_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderItem extends StatelessWidget {
  final String gender;
  final String id;
  GenderItem({
    Key? key,
    required this.gender,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.watch<GenderCubit>().isSelected(id);

    borderColor() {
      if (isSelected) {
        return primaryColor;
      } else {
        return greyColor;
      }
    }

    textColor() {
      if (isSelected) {
        return primaryTextStyle.copyWith(
          fontSize: 14,
          fontWeight: semiBold,
        );
      } else {
        return blackTextStyle.copyWith(
          fontSize: 14,
          fontWeight: regular,
        );
      }
    }

    return GestureDetector(
      onTap: () {
        context.read<GenderCubit>().selected(id);
      },
      child: Container(
        width: 100,
        height: 35,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        child: Center(
          child: Text(
            gender,
            style: textColor(),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor(),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
        ),
      ),
    );
  }
}
