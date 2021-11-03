import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/supir/halaman_kendali_supir_page.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';

class SupirPage extends StatefulWidget {
  const SupirPage({Key? key}) : super(key: key);

  @override
  _SupirPageState createState() => _SupirPageState();
}

class _SupirPageState extends State<SupirPage> {
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
                    var listRes = state.list;

                    var unique = <String, bool>{};
                    for (var key in listRes) {
                      unique[key.transaction!.tanggalBerangkat] = true;
                    }

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
                        SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 40,
                              ),
                              child: Column(
                                children: unique.keys
                                    .map(
                                      (e) => SingleTextCard(
                                        text: 'Keberangkatan $e',
                                        onPressed: () {
                                          List<ResTransaciton> listGroup = [];

                                          for (var element in listRes) {
                                            if (element.transaction!
                                                    .tanggalBerangkat ==
                                                e) {
                                              listGroup.add(element);
                                            }
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HalamanKendaliSupirPage(
                                                      listRes: listGroup),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                              )),
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
