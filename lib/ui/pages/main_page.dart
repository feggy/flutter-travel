// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/page_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/history_page.dart';
import 'package:travel_wisata/ui/pages/home_page.dart';
import 'package:travel_wisata/ui/pages/profile_page.dart';
import 'package:travel_wisata/ui/pages/transaction_page.dart';
import 'package:travel_wisata/ui/widgets/bottom_navigation_item.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildContent(int index) {
      switch (index) {
        case 0:
          return HomePage();
        case 1:
          return TransactionPage();
        case 2:
          return HistoryPage();
        case 3:
          return ProfilePage();
        default:
          return HomePage();
      }
    }

    Widget customBottomNavigation() {
      return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Divider(
              color: grey3Color,
              height: 1,
            ),
            SizedBox(
              height: 59,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: BottomNavigationItem(
                      image: BlocProvider.of<PageCubit>(context).state == 0
                          ? 'assets/ic_home.png'
                          : 'assets/ic_home_off.png',
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                      image: BlocProvider.of<PageCubit>(context).state == 1
                          ? 'assets/ic_transaction.png'
                          : 'assets/ic_transaction_off.png',
                      index: 1,
                    ),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                      image: BlocProvider.of<PageCubit>(context).state == 2
                          ? 'assets/ic_history.png'
                          : 'assets/ic_history_off.png',
                      index: 2,
                    ),
                  ),
                  Expanded(
                    child: BottomNavigationItem(
                      image: BlocProvider.of<PageCubit>(context).state == 3
                          ? 'assets/ic_profile.png'
                          : 'assets/ic_profile_off.png',
                      index: 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<PageCubit, int>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            var state = context.read<PageCubit>().state;
            if (state != 0) {
              context.read<PageCubit>().reset();
            } else {
              return true;
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: whiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: buildContent(state),
                  ),
                  customBottomNavigation(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
