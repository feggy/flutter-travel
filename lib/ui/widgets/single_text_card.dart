import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';

class SingleTextCard extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final EdgeInsets margin;
  final bool noIcon;

  const SingleTextCard({
    Key? key,
    required this.text,
    required this.onPressed,
    this.margin = const EdgeInsets.only(bottom: 15),
    this.noIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: grey2Color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                ),
              ),
              noIcon
                  ? const SizedBox()
                  : const Image(
                      image: AssetImage('assets/ic_enter.png'),
                      width: 15,
                      height: 15,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
