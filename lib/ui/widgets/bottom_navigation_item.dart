import 'package:flutter/material.dart';
import 'package:travel_wisata/cubit/page_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationItem extends StatelessWidget {
  final int index;
  final String image;

  const BottomNavigationItem(
      {Key? key, required this.image, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Column(
    //     children: [
    //       IconButton(
    //         onPressed: () {
    //           context.read<PageCubit>().setPage(index);
    //         },
    //         icon: Image.asset(
    //           image,
    //           height: 21,
    //         ),
    //       ),
    //       Container(
    //         width: 30,
    //         height: 2,
    //         color: context.read<PageCubit>().state == index
    //             ? blackColor
    //             : transparentColor,
    //       ),
    //     ],
    //   ),
    // );

    return InkWell(
      onTap: () {
        context.read<PageCubit>().setPage(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Image.asset(
            image,
            height: 21,
          ),
          Container(
            width: 30,
            height: 2,
            color: context.read<PageCubit>().state == index
                ? blackColor
                : transparentColor,
          ),
        ],
      ),
    );
  }
}
