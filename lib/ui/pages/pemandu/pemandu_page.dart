import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/halaman_kendali_pemandu.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class PemanduPage extends StatefulWidget {
  const PemanduPage({Key? key}) : super(key: key);

  @override
  State<PemanduPage> createState() => _PemanduPageState();
}

class _PemanduPageState extends State<PemanduPage> {
  var email = '';
  getPref() async {
    await SharedPreferences.getInstance().then((value) {
      email = value.getString('email') ?? '';
    });
    context.read<TransactionCubit>().getListJob(email: email);
  }

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().reset();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    void removePref() async {
      final pref = await SharedPreferences.getInstance();
      pref.clear();
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionSuccessJob) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 40,
                          ),
                          child: Text(
                            'Daftar Pekerjaan',
                            style: blackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 40,
                            ),
                            children: state.list.map((e) {
                              var nama = '';
                              var harga =
                                  'Tanggal berangkat ${e.transaction!.tanggalBerangkat}';
                              var imageUrl = '';
                              var status = e.transaction!.status;

                              if (e.transaction!.category == 'TRAVEL') {
                                nama = e.travel!.nama;
                                imageUrl = e.travel!.imageUrl;
                              } else {
                                nama = e.wisata!.nama;
                                imageUrl = e.wisata!.imageUrl;
                              }

                              return InkWell(
                                onTap: () async {
                                  if (e.transaction!.category == 'WISATA') {
                                    await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HalamanKendaliPemandu(
                                                data: e.wisata!,
                                                role: ROLE.pemandu,
                                                res: e,
                                              ),
                                            ))
                                        .then((value) => context
                                            .read<TransactionCubit>()
                                            .getListJob(email: email));
                                  }
                                },
                                child: Model2Card(
                                  nama: nama,
                                  harga: harga,
                                  deskripsi: '',
                                  imageUrl: imageUrl,
                                  status: status,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  } else if (state is TransactionFailedJob) {
                    return NotFoundItem(
                        text: 'Belum ada agenda sedang\nberlangsung');
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            CustomButton(
                title: 'UBAH PROFIL',
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/ubah_profil');
                }),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthInitial) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                } else if (state is AuthFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    backgroundColor: redColor,
                  ));
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return CustomButton(
                    title: 'LOGOUT',
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    onPressed: () {
                      removePref();
                      context.read<AuthCubit>().logout();
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
