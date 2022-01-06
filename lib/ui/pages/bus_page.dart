import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/bus_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';

class BusPage extends StatefulWidget {
  const BusPage({Key? key}) : super(key: key);

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  @override
  void initState() {
    super.initState();
    context.read<TravelCubit>().getListTravel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Pesan Tiket Travel'),
      body: BlocBuilder<TravelCubit, TravelState>(
        builder: (context, state) {
          if (state is TravelSuccess) {
            return ListView(
                padding: EdgeInsets.only(
                  left: horizontalMargin,
                  right: horizontalMargin,
                  top: 50,
                ),
                children: state.travel
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusDetailPage(
                                  data: e,
                                  role: ROLE.user,
                                ),
                              ),
                            );
                          },
                          child: Model2Card(
                            nama: e.nama,
                            harga: e.biaya.toString(),
                            deskripsi: e.kelas,
                            imageUrl: e.imageUrl,
                          ),
                        ))
                    .toList());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
