import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/supir_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/tambah_pemandu_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

class DaftarSupirPage extends StatefulWidget {
  const DaftarSupirPage({Key? key}) : super(key: key);

  @override
  State<DaftarSupirPage> createState() => _DaftarSupirPageState();
}

class _DaftarSupirPageState extends State<DaftarSupirPage> {
  @override
  void initState() {
    context.read<SupirCubit>().getListSupir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonTambah() {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          top: 20,
        ),
        child: CustomButton(
            title: 'TAMBAH',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahPemanduPage(role: 'SUPIR'),
                ),
              ).then((value) {
                context.read<SupirCubit>().getListSupir();
              });
            }),
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Supir'),
      backgroundColor: whiteColor,
      body: BlocBuilder<SupirCubit, SupirState>(
        builder: (context, state) {
          if (state is SupirSuccess) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: state.list
                            .map(
                              (e) => SingleTextCard(
                                text: e.name,
                                onPressed: () {},
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  buttonTambah(),
                ],
              ),
            );
          } else if (state is SupirFailed) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: NotFoundItem(text: state.error),
                    ),
                  ),
                  buttonTambah(),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
