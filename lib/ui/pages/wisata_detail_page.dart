// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/cubit/alasan_cubit.dart';
import 'package:travel_wisata/models/alasan_model.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/tambah_wisata_page.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/hari_agenda_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'isi_data_wisata_page.dart';

class WisataDetailPage extends StatefulWidget {
  final WisataModel data;
  final ROLE role;
  ResTransaciton? res;

  WisataDetailPage({
    Key? key,
    required this.data,
    required this.role,
    this.res,
  }) : super(key: key);

  @override
  State<WisataDetailPage> createState() => _WisataDetailPageState();
}

class _WisataDetailPageState extends State<WisataDetailPage> {
  var tglBerangkat = 'Pilih tanggal';
  List<AlasanModel> listAlasan = [];

  @override
  void initState() {
    super.initState();
    if (widget.res != null) {
      if (widget.res!.transaction!.status == 2) {
        var res = widget.res!.transaction!;
        context.read<AlasanCubit>().getAlasan(
            idInvoice: res.idInvoice,
            idTravel: res.idTravel,
            pemandu: res.jobFor);
      }
    }
  }

  @override
  void dispose() {
    context.read<AlasanCubit>().reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget coverHeader() {
      return Image.network(
        widget.data.imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
      );
    }

    Widget titleRating() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.data.nama,
              style: blackTextStyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // SizedBox(
          //   width: 45,
          //   height: 25,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Image.asset(
          //           'assets/ic_star.png',
          //           width: 20,
          //           height: 20,
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 5,
          //       ),
          //       Text(
          //         '4.0',
          //         style: blackTextStyle.copyWith(
          //           fontSize: 14,
          //           fontWeight: semiBold,
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      );
    }

    String newSubtitle = "";
    newSubtitle = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.data.biaya);

    Widget deskripsiPrice() {
      return Row(
        children: [
          Expanded(
            child: Text(
              widget.data.deskripsiHari,
              style: greyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: regular,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            newSubtitle,
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: medium,
            ),
          ),
        ],
      );
    }

    Widget agenda() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agenda Perjalanan',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: semiBold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
          if (widget.data.agenda.isNotEmpty)
            Column(
                children: widget.data.agenda
                    .map(
                      (e) => HariAgendaItem(data: e),
                    )
                    .toList())
          else
            Center(
              child: Text(
                'Belum ada agenda yang ditambahkan',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            ),
        ],
      );
    }

    Widget inputDate() {
      DateFormat formatter = DateFormat('dd MMM yyyy');

      bool _decideWhichDayToEnable(DateTime day) {
        if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
            day.isBefore(DateTime.now().add(const Duration(days: 90))))) {
          return true;
        }
        return false;
      }

      return GestureDetector(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030),
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            // selectableDayPredicate: _decideWhichDayToEnable,
          ).then((value) {
            setState(() {
              tglBerangkat = formatter.format(value!);
              log(tglBerangkat);
            });
          });
        },
        child: Container(
            width: 100,
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tglBerangkat,
                  style: blackTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: regular,
                  ),
                ),
                Divider(
                  height: 0.5,
                  color: blackColor,
                ),
              ],
            )),
      );
    }

    Widget tanggalBerangkat() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Tanggal keberangakatan',
              style:
                  blackTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/ic_jam.png',
                  width: 20,
                  height: 20,
                ),
                inputDate(),
              ],
            ),
          )
        ],
      );
    }

    Widget footerPesan() {
      return Padding(
        padding: EdgeInsets.only(
          left: horizontalMargin,
          right: horizontalMargin,
          top: 10,
          bottom: 30,
        ),
        child: Column(
          children: [
            tanggalBerangkat(),
            const SizedBox(
              height: 25,
            ),
            CustomButton(
                title: 'PESAN SEKARANG',
                onPressed: () {
                  if (tglBerangkat == "Pilih tanggal") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Pilih tanggal keberangkatn terlebih dahulu'),
                        backgroundColor: redColor,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPendaftaranPage(
                          category: 'WISATA',
                          tglBerangkat: tglBerangkat,
                          dataWisata: widget.data,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      );
    }

    Widget alasan() {
      return BlocBuilder<AlasanCubit, AlasanState>(
        builder: (context, state) {
          if (state is SuccessGetAlasan) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: 'Catatan: ',
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: semiBold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Ada perubahan Jadwal',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: medium,
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 10),
                Text(
                  'Alasan Perubahan',
                  style: blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: semiBold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.listAlasan
                      .map(
                        (e) => Text.rich(
                          TextSpan(
                              text: '- ',
                              style: blackTextStyle.copyWith(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: e.alasan,
                                ),
                              ]),
                        ),
                      )
                      .toList(),
                )
              ],
            );
          }
          return const SizedBox();
        },
      );
    }

    Widget footerAdmin() {
      return CustomButton(
          title: 'UBAH',
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TambahWisataPage(
                  data: widget.data,
                ),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: whiteColor,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    coverHeader(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: horizontalMargin,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleRating(),
                          const SizedBox(
                            height: 5,
                          ),
                          deskripsiPrice(),
                          const SizedBox(
                            height: 25,
                          ),
                          agenda(),
                          const SizedBox(
                            height: 10,
                          ),
                          alasan(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            widget.role == ROLE.user && widget.res == null
                ? footerPesan()
                : const SizedBox(),
            widget.role == ROLE.admin ? footerAdmin() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
