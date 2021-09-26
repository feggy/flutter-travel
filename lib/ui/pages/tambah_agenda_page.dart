import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class TambahAgendaPage extends StatefulWidget {
  const TambahAgendaPage({Key? key}) : super(key: key);

  @override
  State<TambahAgendaPage> createState() => _TambahAgendaPageState();
}

class _TambahAgendaPageState extends State<TambahAgendaPage> {
  DateFormat formatter = DateFormat('HH:mm');

  String timeStart = '';
  String timeEnd = '';
  int dayNumber = 0;

  final dayOfNumberController = TextEditingController(text: '');
  final deskripsiController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget inputTime() {
      return Row(
        children: [
          Image.asset(
            'assets/ic_jam.png',
            width: 20,
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!);
                  }).then((value) {
                final result =
                    MaterialLocalizations.of(context).formatTimeOfDay(value!);
                final time = DateFormat.jm().parse(result);
                setState(() {
                  timeStart = formatter.format(time);
                });
              });
            },
            child: Container(
                width: 50,
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeStart.isEmpty ? 'mulai' : timeStart,
                      style: blackTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: regular,
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      color: blackColor,
                    ),
                  ],
                )),
          ),
          const Text(' - '),
          GestureDetector(
            onTap: () {
              showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, child) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: child!);
                  }).then((value) {
                final result =
                    MaterialLocalizations.of(context).formatTimeOfDay(value!);
                final time = DateFormat.jm().parse(result);
                setState(() {
                  timeEnd = formatter.format(time);
                });
              });
            },
            child: Container(
                width: 50,
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeEnd.isEmpty ? 'akhir' : timeEnd,
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
          ),
        ],
      );
    }

    Widget inputDeskripsi() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/ic_note.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: blackTextStyle.copyWith(
                fontSize: 12,
              ),
              controller: deskripsiController,
              decoration: InputDecoration(
                hintText: 'Deskripsi perjalanan',
                hintStyle: greyTextStyle.copyWith(
                  fontSize: 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: greyColor,
                    width: 0.3,
                  ),
                ),
                isDense: true,
              ),
            ),
          )
        ],
      );
    }

    Widget button() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            title: 'BATAL',
            width: 100,
            height: 35,
            color: redColor,
            textStyle: whiteTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          CustomButton(
            title: 'SIMPAN',
            width: 100,
            height: 35,
            textStyle: whiteTextStyle.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
            onPressed: () {
              String errorMsg = '';
              if (dayNumber == 0) {
                errorMsg = 'Keterangan hari belum diatur';
              } else if (timeStart.isEmpty) {
                errorMsg = 'Waktu mulai harus di isi';
              } else if (timeEnd.isEmpty) {
                errorMsg = 'Waktu akhir harus di isi';
              } else if (deskripsiController.text.isEmpty) {
                errorMsg = 'deskripsi harus di isi';
              }

              if (errorMsg.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                List<AgendaModel> listAgenda = [
                  AgendaModel(
                    dayOfNumber: dayNumber,
                    startTime: timeStart,
                    endTime: timeEnd,
                    deskripsi: deskripsiController.text,
                  )
                ];
                final agenda =
                    HariModel(dayOfNumber: dayNumber, agenda: listAgenda);
                Navigator.pop(context, agenda);
              }
            },
          )
        ],
      );
    }

    Widget dayOfNumber() {
      return Row(
        children: [
          Image.asset(
            'assets/ic_calendar.png',
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Agenda Hari ke :',
            style: blackTextStyle,
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              if (dayNumber != 0) {
                setState(() {
                  dayNumber -= 1;
                });
              }
            },
            child: Image.asset(
              'assets/ic_minus.png',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                dayNumber.toString(),
                style: blackTextStyle,
              ),
              Container(
                height: 0.5,
                width: 30,
                color: blackColor,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                dayNumber += 1;
              });
            },
            child: Image.asset(
              'assets/ic_plus.png',
              width: 20,
              height: 20,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Tambah Agenda'),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
          ),
          child: Column(
            children: [
              dayOfNumber(),
              const SizedBox(
                height: 20,
              ),
              inputTime(),
              const SizedBox(
                height: 20,
              ),
              inputDeskripsi(),
              const SizedBox(
                height: 30,
              ),
              button(),
            ],
          ),
        ),
      ),
    );
  }
}
