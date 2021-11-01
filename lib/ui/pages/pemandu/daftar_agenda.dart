// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/ubah_agenda_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

class DaftarAgenda extends StatefulWidget {
  ResTransaciton res;

  DaftarAgenda({Key? key, required this.res}) : super(key: key);

  @override
  State<DaftarAgenda> createState() => _DaftarAgendaState();
}

List<HariModel> dataAgenda = [];
TextEditingController alasanController = TextEditingController(text: '');

class _DaftarAgendaState extends State<DaftarAgenda> {
  @override
  void initState() {
    super.initState();
    dataAgenda = widget.res.wisata!.agenda;
    alasanController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    Widget titleHari(HariModel data) {
      return Text(
        'Hari ke ${data.dayOfNumber}',
        style: blackTextStyle.copyWith(
          fontSize: 12,
          fontWeight: medium,
        ),
      );
    }

    Widget listAgenda(HariModel data) {
      data.agenda = data.agenda
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return Column(
        children: data.agenda
            .map((e) => GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UbahAgendaPage(
                          dayNumber: data.dayOfNumber,
                          agenda: e,
                        ),
                      ),
                    ).then((value) {
                      log('value $value');
                      if (value != null) {
                        HariModel set = value;

                        setState(() {
                          dataAgenda
                              .firstWhere((element) => element == data)
                              .agenda
                              .remove(e);

                          dataAgenda
                              .firstWhere((element) => element == data)
                              .agenda
                              .add(set.agenda[0]);
                        });
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 90,
                          child: Text(
                            '${e.startTime} - ${e.endTime}',
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: regular,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.deskripsi,
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                              fontWeight: regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
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
          if (dataAgenda.isNotEmpty)
            Column(
                children: dataAgenda
                    .map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titleHari(e),
                          listAgenda(e),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
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
          const SizedBox(
            height: 25,
          ),
          Text(
            'Alasan perubahan',
            style: blackTextStyle.copyWith(
              fontSize: 12,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          CustomInputText(
            label: 'Alasan',
            controller: alasanController,
          ),
        ],
      );
    }

    showLoaderDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: const Text("Loading...")),
          ],
        ),
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialog(
      String title,
      String desc,
      Function()? onPressed,
    ) {
      Widget cancelButton = TextButton(
        child: const Text("Tidak"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      Widget continueButton = TextButton(
        child: const Text("Ya"),
        onPressed: onPressed,
      );

      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Daftar Agenda'),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: agenda(),
            ),
          ),
          CustomButton(
            title: 'SIMPAN',
            margin: const EdgeInsets.all(20),
            onPressed: () {
              String alasan = alasanController.text;
              if (alasan.isNotEmpty) {
                showAlertDialog('Ubah Agenda',
                    'Pastikan data sudah benar, apakah Anda yakin melakukan perubahan?',
                    () async {
                  showLoaderDialog(context);
                  await WisataService()
                      .updateAgenda(
                          id: widget.res.wisata!.id,
                          pemandu: widget.res.wisata!.pemandu,
                          agenda: dataAgenda,
                          alasan: alasanController.text,
                          idInvoice: widget.res.transaction!.idInvoice,
                          idTravel: widget.res.transaction!.idTravel)
                      .then((value) {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/pemandu_home', (route) => false);
                    log('_ $value');
                  });
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Alasan harus di tulis'),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
