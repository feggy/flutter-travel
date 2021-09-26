// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:travel_wisata/cubit/jumlah_kursi_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JumlahKursiItem extends StatelessWidget {
  JumlahKursiItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jumlah Kursi',
              style: blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/ic_kursi.png',
                    width: 20,
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<JumlahKursiCubit>().min(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 5,
                      ),
                      child: Image.asset(
                        'assets/ic_minus.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  BlocBuilder<JumlahKursiCubit, int>(
                    builder: (context, state) {
                      return Container(
                        width: 40,
                        margin: const EdgeInsets.only(
                          left: 5,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.toString(),
                              style: blackTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: regular,
                              ),
                            ),
                            Divider(
                              height: 0.5,
                              color: blackColor,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<JumlahKursiCubit>().add(1);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Image.asset(
                        'assets/ic_plus.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
