import 'dart:developer';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/services/transaction_service.dart';
import 'package:travel_wisata/services/travel_service.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

class TambahLaporanTransaksiPage extends StatefulWidget {
  const TambahLaporanTransaksiPage({Key? key}) : super(key: key);

  @override
  State<TambahLaporanTransaksiPage> createState() =>
      _TambahLaporanTransaksiPageState();
}

class _TambahLaporanTransaksiPageState
    extends State<TambahLaporanTransaksiPage> {
  String dropdownValue = 'Pilih Kategori';
  String dropDownValueWisata = 'Pilih Wisata';
  String dropDownValueTravel = 'Pilih Travel';
  String dropDownValueBulan = 'Pilih Bulan';

  List<String> dropWisata = ['Pilih Wisata'];
  List<String> dropTravel = ['Pilih Travel'];
  List<String> dropKateogri = ['Pilih Kategori', 'Wisata', 'Travel'];
  List<String> dropBulan = [
    'Pilih Bulan',
    'January 2022',
    'February 2022',
    'March 2022',
    'April 2022',
    'May 2022',
    'June 2022',
    'July 2022',
    'August 2022',
    'September 2022',
    'October 2022',
    'November 2022',
    'December 2022'
  ];

  List<WisataModel> listWisata = [];
  List<TravelModel> listTravel = [];

  List<ResTransaciton> listTransaction = [];
  List<ResTransaciton> listForRecap = [];

  List<Pengeluaran> listPengeluaran = [];

  String idWisata = '';
  String idTravel = '';

  int totalUangMasuk = 0;
  int totalUangKeluar = 0;
  int hargaPaket = 0;

  var namaController = TextEditingController(text: '');
  var qtyController = TextEditingController(text: '');
  var biayaController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget dropDown({
      required String title,
      required List<String> list,
      required String dropValue,
      required Function(String?)? onChanged,
    }) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            margin: const EdgeInsets.only(top: 7.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  width: 1,
                  color: Colors.black45,
                )),
            child: DropdownButton(
              value: dropValue,
              onChanged: onChanged,
              iconEnabledColor: Colors.transparent,
              iconDisabledColor: Colors.transparent,
              isDense: true,
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                    style: blackTextStyle.copyWith(
                      fontWeight: regular,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10),
              color: whiteColor,
              child: Text(
                ' $title ',
                style: greyTextStyle.copyWith(fontSize: 12),
              )),
        ],
      );
    }

    Widget dialogTambahPengeluaran() {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3),
            color: whiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Tambah Data Pengeluaran',
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close_rounded),
                        iconSize: 20,
                        splashRadius: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                CustomInputText(label: 'Nama', controller: namaController),
                const SizedBox(height: 20),
                CustomInputText(
                  label: 'Jumlah',
                  controller: qtyController,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20),
                CustomInputText(
                  label: 'Biaya',
                  controller: biayaController,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 30),
                CustomButton(
                  title: 'SIMPAN',
                  onPressed: () {
                    String? error;
                    if (namaController.text.isEmpty) {
                      error = 'Nama tidak boleh kosong';
                    } else if (qtyController.text.isEmpty) {
                      error = 'Jumlah tidak boleh kosong';
                    } else if (biayaController.text.isEmpty) {
                      error = 'Biaya tidak boleh kosong';
                    }

                    if (error != null) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Gagal'),
                          content: Text(error!),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      setState(() {
                        listPengeluaran.add(
                          Pengeluaran(
                            nama: namaController.text,
                            qty: int.parse(qtyController.text),
                            biaya: int.parse(biayaController.text),
                          ),
                        );
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget headerPengeluaran() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Data Pengeluaran',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => dialogTambahPengeluaran(),
                );
              },
              child: Text(
                'Tambah Pengeluaran',
                style: blackTextStyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                  color: Colors.blue[800],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget totalPengeluaran() {
      if (listPengeluaran.isNotEmpty) {
        for (var element in listPengeluaran) {
          totalUangKeluar += (element.biaya * element.qty);
        }
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: Text.rich(TextSpan(
              text: 'Total Uang Keluar ',
              style: blackTextStyle,
              children: [
                TextSpan(
                    text: NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(totalUangKeluar),
                    style: blackTextStyle.copyWith(fontWeight: semiBold)),
              ])),
        );
      }
      return const SizedBox();
    }

    Widget kategori() {
      return dropDown(
        title: 'Kategori',
        list: dropKateogri,
        dropValue: dropdownValue,
        onChanged: (p0) async {
          listTransaction =
              await TransactionService().getListTransaction(email: 'admin');
          if (p0 == 'Wisata') {
            listWisata = await WisataService().getListWisata();
            if (dropWisata.length > 1) {
              dropWisata.removeWhere((element) => element != 'Pilih Wisata');
            }
          } else if (p0 == 'Travel') {
            listTravel = await TravelService().getListTravel();
            if (dropTravel.length > 1) {
              dropTravel.removeWhere((element) => element != 'Pilih Travel');
            }
          }
          setState(() {
            dropdownValue = p0!;
            idWisata = '';
            idTravel = '';
            dropDownValueBulan = 'Pilih Bulan';
            listTransaction;
            if (p0 == 'Wisata') {
              dropDownValueTravel = 'Pilih Travel';
              for (var element in listWisata) {
                dropWisata.add(element.nama);
              }
            } else if (p0 == 'Travel') {
              dropDownValueWisata = 'Pilih Wisata';
              for (var element in listTravel) {
                dropTravel.add(element.nama);
              }
            }
          });
        },
      );
    }

    Widget wisata() {
      return listWisata.isNotEmpty && dropdownValue == 'Wisata'
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              child: dropDown(
                title: 'Wisata',
                list: dropWisata,
                dropValue: dropDownValueWisata,
                onChanged: (p0) {
                  setState(() {
                    dropDownValueWisata = p0!;
                    dropDownValueBulan = 'Pilih Bulan';
                    idWisata = listWisata
                        .firstWhere((element) => element.nama == p0)
                        .id;
                  });
                },
              ),
            )
          : const SizedBox();
    }

    Widget travel() {
      return listTravel.isNotEmpty && dropdownValue == 'Travel'
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              child: dropDown(
                title: 'Travel',
                list: dropTravel,
                dropValue: dropDownValueTravel,
                onChanged: (p0) {
                  setState(() {
                    dropDownValueTravel = p0!;
                    dropDownValueBulan = 'Pilih Bulan';
                    idTravel = listTravel
                        .firstWhere((element) => element.nama == p0)
                        .id;
                  });
                },
              ),
            )
          : const SizedBox();
    }

    Widget paket() {
      return dropDownValueWisata != 'Pilih Wisata' ||
              dropDownValueTravel != 'Pilih Travel'
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              child: dropDown(
                title: 'Bulan',
                list: dropBulan,
                dropValue: dropDownValueBulan,
                onChanged: (p0) {
                  listForRecap = [];
                  for (var element in listTransaction) {
                    if (dropdownValue == 'Wisata' &&
                        element.transaction?.idTravel == idWisata) {
                      hargaPaket = element.wisata!.biaya;
                      var monthRes = DateFormat("MMMM yyyy")
                          .format(element.transaction!.timeCreated);
                      if (monthRes == p0) {
                        listForRecap.add(element);
                      }
                    } else if (dropdownValue == 'Travel' &&
                        element.transaction?.idTravel == idTravel) {
                      hargaPaket = element.travel!.biaya;
                      var monthRes = DateFormat("MMMM yyyy")
                          .format(element.transaction!.timeCreated);
                      if (monthRes == p0) {
                        listForRecap.add(element);
                      }
                    }
                  }
                  var traveler = 0;
                  for (var element in listForRecap) {
                    traveler += element.transaction!.listTraveler.length;
                  }
                  log('_ $totalUangMasuk');

                  setState(() {
                    dropDownValueBulan = p0!;
                    listForRecap;
                    totalUangMasuk = hargaPaket * traveler;
                  });
                },
              ),
            )
          : const SizedBox();
    }

    Widget totalPemasukkan() {
      return listForRecap.isNotEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text.rich(TextSpan(
                  text: 'Total Uang Masuk ',
                  style: blackTextStyle,
                  children: [
                    TextSpan(
                        text: NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        ).format(totalUangMasuk),
                        style: blackTextStyle.copyWith(fontWeight: semiBold)),
                  ])),
            )
          : const SizedBox();
    }

    Widget dataPengeluaran() {
      return listPengeluaran.isEmpty
          ? Center(
              child: Text(
                'Belum ada data pengeluaran yang ditambahkan',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: medium,
                ),
              ),
            )
          : DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              // ignore: prefer_const_literals_to_create_immutables
              columns: [
                const DataColumn2(
                  label: Text('Nama'),
                  size: ColumnSize.L,
                ),
                const DataColumn(
                  label: Text('Jumlah'),
                ),
                const DataColumn(
                  label: Text('Biaya'),
                ),
              ],
              rows: List<DataRow>.generate(listPengeluaran.length, (index) {
                var item = listPengeluaran[index];
                return DataRow(cells: [
                  DataCell(Text(item.nama)),
                  DataCell(Text(item.qty.toString())),
                  DataCell(Text(item.biaya.toString())),
                ]);
              }),
            );
    }

    Widget btnSimpan() {
      return CustomButton(
        title: 'SIMPAN',
        onPressed: () {
          String? error;
          if (dropdownValue == 'Pilih Kategori') {
            error = 'Silahkan pilih kategori terlebih dahulu';
          } else if (dropdownValue == 'Wisata' &&
              dropDownValueWisata == 'Pilih Wisata') {
            error = 'Silahkan pilih wisata terlebih dahulu';
          } else if (dropdownValue == 'Travel' &&
              dropDownValueTravel == 'Pilih Travel') {
            error = 'Silahkan pilih travel terlebih dahulu';
          } else if (dropDownValueBulan == 'Pilih Bulan') {
            error = 'Silahkan pilih bulan terlebih dahulu';
          } else if (listPengeluaran.isEmpty) {
            error = 'Anda belum menambahkan data pengeluaran';
          }

          if (error != null) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Gagal'),
                content: Text(error!),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
              ),
            );
          } else {}
        },
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Laporan Transaksi Baru'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 3),
        children: [
          const SizedBox(
            height: 50,
          ),
          kategori(),
          wisata(),
          travel(),
          paket(),
          totalPemasukkan(),
          headerPengeluaran(),
          dataPengeluaran(),
          totalPengeluaran(),
          const SizedBox(
            height: 50,
          ),
          btnSimpan()
        ],
      ),
    );
  }
}

class Pengeluaran {
  String nama;
  int qty;
  int biaya;
  Pengeluaran({
    required this.nama,
    required this.qty,
    required this.biaya,
  });
}
