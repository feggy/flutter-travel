import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:travel_wisata/models/laporan_transaksi_model.dart';
import 'package:travel_wisata/services/laporan_transaksi_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

import '../../../main.dart';

class LaporanTransaksiPage extends StatefulWidget {
  const LaporanTransaksiPage({Key? key}) : super(key: key);

  @override
  State<LaporanTransaksiPage> createState() => _LaporanTransaksiPageState();
}

class _LaporanTransaksiPageState extends State<LaporanTransaksiPage> {
  List<LaporanTransaksiModel> dataList = [];

  List<String> bulan = ['Pilih bulan'];
  List<String> namaPaket = ['Pilih Paket'];

  String dropBulan = 'Pilih bulan';
  String dropNama = 'Pilih Paket';

  List<Table> dataTable = [];

  int totalUangMasuk = 0;
  int totalUangKeluar = 0;

  String id = '';

  @override
  void initState() {
    LaporanTransaksiService().get().then((value) {
      log('_ $value');
      if (value.isNotEmpty) {
        setState(() {
          dataList = value;
          for (var element in dataList) {
            bulan.add(DateFormat('MMMM yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    element.bulan.millisecondsSinceEpoch)));
            namaPaket.add(element.nama);
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropDown({
      required List<String> list,
      required String dropValue,
      required Function(String?)? onChanged,
    }) {
      return DropdownButton(
        value: dropValue,
        onChanged: onChanged,
        iconEnabledColor: Colors.transparent,
        iconDisabledColor: Colors.transparent,
        isDense: true,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem(
            value: value,
            child: SizedBox(
              width: 250,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: blackTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    Widget total(String title, int total) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: blackTextStyle,
          ),
          SizedBox(
            width: 100,
            child: Text(
              NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(total),
              style: blackTextStyle.copyWith(fontWeight: semiBold),
              textAlign: TextAlign.end,
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Laporan Transaksi'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Container(
                width: 150,
                height: 30,
                alignment: Alignment.topRight,
                child: CustomButton(
                    title: 'Tambah Baru',
                    onPressed: () {
                      Navigator.pushNamed(
                              context, Routes.tambahLaporanTransaksiPage)
                          .then((value) {
                        if (value == true) {
                          LaporanTransaksiService().get().then((value) {
                            log('_ $value');
                            if (value.isNotEmpty) {
                              setState(() {
                                dataList = value;
                                for (var element in dataList) {
                                  bulan.add(DateFormat('MMMM yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          element
                                              .bulan.millisecondsSinceEpoch)));
                                  namaPaket.add(element.nama);
                                }
                              });
                            }
                          });
                        }
                      });
                    }),
              ),
            ],
          ),
          Wrap(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      dropDown(
                        list: bulan,
                        dropValue: dropBulan,
                        onChanged: (p0) {
                          dataTable.clear();

                          setState(() {
                            if (p0 != null) {
                              dropBulan = p0;
                            }
                          });
                        },
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      dropDown(
                        list: namaPaket,
                        dropValue: dropNama,
                        onChanged: (p0) {
                          dataTable.clear();

                          setState(() {
                            if (p0 != null) {
                              dropNama = p0;

                              for (var element in dataList) {
                                if (element.nama == p0 &&
                                    DateFormat('MMMM yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                element.bulan
                                                    .millisecondsSinceEpoch)) ==
                                        dropBulan) {
                                  id = element.id;
                                  totalUangMasuk = element.totalPemasukkan;
                                  totalUangKeluar = element.totalPengeluaran;

                                  dataTable.add(Table(
                                      deskripsi: 'Tiket Perjalanan',
                                      jumlah: element.banyakPeserta.toString(),
                                      biaya: NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp',
                                        decimalDigits: 0,
                                      ).format(element.biayaPaket),
                                      kategori: 'Pemasukkan'));

                                  for (var element in element.listPengeluaran) {
                                    dataTable.add(Table(
                                        deskripsi: element.nama,
                                        jumlah: element.qty.toString(),
                                        biaya: NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp',
                                          decimalDigits: 0,
                                        ).format(element.biaya),
                                        kategori: 'Pengeluaran'));
                                  }
                                }
                              }
                            }
                          });
                        },
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                  const SizedBox(height: 100),
                  dropBulan != 'Pilih bulan' && dropNama != 'Pilih Paket'
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Kode Laporan: $id',
                                      style: blackTextStyle),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Hapus Laporan',
                                            style: blackTextStyle.copyWith(
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                          content: Text(
                                            'Apakah Anda yakin menghapus data laporan ini?',
                                            style: blackTextStyle.copyWith(
                                              fontWeight: medium,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Tidak',
                                                style: blackTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: Text(
                                                'Ya',
                                                style: blackTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: semiBold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).then((value) async {
                                        if (value == true) {
                                          showLoaderDialog(context);
                                          await LaporanTransaksiService()
                                              .delete(id: id)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text('Berhasil'),
                                                content: const Text(
                                                    'Anda berhasil menghapus data laporan transaksi'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            Routes.admin);
                                                      },
                                                      child: const Text('OK'))
                                                ],
                                              ),
                                            );
                                          });
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Hapus Laporan',
                                      style: blackTextStyle.copyWith(
                                        color: Colors.red,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              DataTable2(
                                  columnSpacing: 12,
                                  horizontalMargin: 12,
                                  minWidth: 600,
                                  border: TableBorder(
                                      top: BorderSide(color: Colors.grey[300]!),
                                      bottom:
                                          BorderSide(color: Colors.grey[300]!),
                                      left:
                                          BorderSide(color: Colors.grey[300]!),
                                      right:
                                          BorderSide(color: Colors.grey[300]!),
                                      verticalInside:
                                          BorderSide(color: Colors.grey[300]!),
                                      horizontalInside: const BorderSide(
                                          color: Colors.grey, width: 1)),
                                  // ignore: prefer_const_literals_to_create_immutables
                                  columns: [
                                    const DataColumn2(
                                      label: Text('Deskripsi'),
                                      size: ColumnSize.L,
                                    ),
                                    const DataColumn(
                                      label: Text('Jumlah'),
                                    ),
                                    const DataColumn(
                                      label: Text('Biaya'),
                                    ),
                                    const DataColumn(
                                      label: Text('Jenis'),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(dataTable.length,
                                      (index) {
                                    var item = dataTable[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item.deskripsi)),
                                        DataCell(Text(item.jumlah)),
                                        DataCell(Text(item.biaya)),
                                        DataCell(Text(item.kategori)),
                                      ],
                                    );
                                  })),
                              const SizedBox(height: 10),
                              total('Subtotal Pemasukkan', totalUangMasuk),
                              total('Subtotal Pengeluaran', totalUangKeluar),
                              total(
                                  (totalUangMasuk - totalUangKeluar) > 0
                                      ? 'Keuntungan'
                                      : 'Kerugian',
                                  totalUangMasuk - totalUangKeluar),
                            ],
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Silahkan pilih bulan dan paket terlebih dahulu',
                            style: blackTextStyle,
                          ),
                        )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Table {
  String deskripsi;
  String jumlah;
  String biaya;
  String kategori;
  Table({
    required this.deskripsi,
    required this.jumlah,
    required this.biaya,
    required this.kategori,
  });
}
