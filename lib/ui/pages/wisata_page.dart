import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/wisata_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/wisata_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class WisataPage extends StatefulWidget {
  const WisataPage({Key? key}) : super(key: key);

  @override
  State<WisataPage> createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  @override
  void initState() {
    super.initState();
    context.read<WisataCubit>().getListWisata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Wisata yuk!'),
      body: BlocBuilder<WisataCubit, WisataState>(
        builder: (context, state) {
          if (state is WisataSuccess) {
            return ListView(
                padding: EdgeInsets.only(
                  left: horizontalMargin,
                  right: horizontalMargin,
                  top: 50,
                ),
                children: state.data
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WisataDetailPage(data: e, role: ROLE.user),
                              ),
                            );
                          },
                          child: Model2Card(
                            nama: e.nama,
                            harga: e.biaya.toString(),
                            deskripsi: e.deskripsiHari,
                            imageUrl: e.imageUrl,
                          ),
                        ))
                    .toList());
          } else if (state is WisataFailed) {
            return NotFoundItem(text: 'Daftar wisata masih kosong');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
