import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/detail_photo_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

class DetailTransactionAdminPage extends StatefulWidget {
  const DetailTransactionAdminPage({Key? key}) : super(key: key);

  @override
  State<DetailTransactionAdminPage> createState() =>
      _DetailTransactionAdminPageState();
}

class _DetailTransactionAdminPageState
    extends State<DetailTransactionAdminPage> {
  ResTransaciton? res;
  var title = '';
  var nama = '';
  var email = '';
  var phone = '';
  var kategori = '';
  var imageUrl = '';
  var jumlah = 0;
  var tglKeberangkatan = '';
  var biaya = '';
  var total = '';
  var status = 0;
  var deskripsiStatus = '';
  var tglTransaksi = '';
  var role = ROLE.admin;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    res = arguments['res'] as ResTransaciton;

    if (arguments['role'] != null) {
      role = arguments['role'];
    }

    var idInvoice = res!.transaction!.idInvoice;
    context.read<TransactionCubit>().getTransaction(idInvoice: idInvoice);

    Widget button() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            context
                .read<TransactionCubit>()
                .getTransaction(idInvoice: idInvoice);
          } else if (state is TransactionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: redColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoadingAdd) {
            return const CircularProgressIndicator();
          }
          return Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 30,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                    child: CustomButton(
                  title: 'TOLAK',
                  color: redColor,
                  onPressed: () {
                    context
                        .read<TransactionCubit>()
                        .updateStatus(idInvoice: idInvoice, status: 3);
                  },
                )),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: CustomButton(
                  title: 'SETUJUI',
                  onPressed: () {
                    context
                        .read<TransactionCubit>()
                        .updateStatus(idInvoice: idInvoice, status: 1);
                  },
                )),
              ],
            ),
          );
        },
      );
    }

    Widget itemRow(String title, String desc) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: blackTextStyle.copyWith(fontSize: 12, fontWeight: regular),
            ),
            Expanded(
              child: Text(
                desc,
                textAlign: TextAlign.end,
                style:
                    blackTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
              ),
            ),
          ],
        ),
      );
    }

    Widget btnCetak() {
      return CustomButton(
          title: 'CETAK',
          color: Colors.grey[100]!,
          textStyle: blackTextStyle.copyWith(fontWeight: semiBold),
          onPressed: () async {
            await screenshotController
                .capture(delay: const Duration(milliseconds: 10))
                .then((image) async {
              log('_ $image');

              final directory = await getApplicationDocumentsDirectory();

              final pdf = pw.Document();

              pdf.addPage(pw.Page(build: (pw.Context context) {
                var widthh = 150.0;
                return pw.Column(children: [
                  pw.Center(
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'Maiga Tour & Travel',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Jl. Inpres, Samping Gg. Sejahtera Pekanbaru, Riau',
                          ),
                          pw.Text(
                            '0761-7436-266 | 0852-6535-9555 | 0852-6429-6524',
                            textAlign: pw.TextAlign.center,
                          ),
                          pw.SizedBox(height: 50),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Detail Pelanggan',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Nama:',
                                    ),
                                  ),
                                  pw.Text(
                                    nama,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Nomor hp:',
                                    ),
                                  ),
                                  pw.Text(
                                    phone,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Email:',
                                    ),
                                  ),
                                  pw.Text(
                                    email,
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                height: 20,
                              ),
                              pw.Text(
                                'Detail Pemesanan',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Id tagihan:',
                                    ),
                                  ),
                                  pw.Text(
                                    idInvoice,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                      width: widthh,
                                      child: pw.Text(
                                        'Nama:',
                                      )),
                                  pw.Text(
                                    title,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Kategori:',
                                    ),
                                  ),
                                  pw.Text(
                                    kategori,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Jumlah pelanggan:',
                                    ),
                                  ),
                                  pw.Text(
                                    '$jumlah Orang',
                                    textAlign: pw.TextAlign.right,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Tanggal keberangkatan:',
                                    ),
                                  ),
                                  pw.Text(
                                    tglKeberangkatan,
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                height: 20,
                              ),
                              pw.Text('Detail Pembayaran',
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(
                                height: 10,
                              ),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Waktu pembayaran:',
                                    ),
                                  ),
                                  pw.Text(
                                    tglTransaksi,
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Biaya:',
                                    ),
                                  ),
                                  pw.Text(
                                    '$biaya/orang',
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 5),
                              pw.Row(
                                children: [
                                  pw.SizedBox(
                                    width: widthh,
                                    child: pw.Text(
                                      'Total Pembayaran:',
                                    ),
                                  ),
                                  pw.Text(total,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ]);
              }));

              if (res!.transaction!.category == 'WISATA') {
                pdf.addPage(pw.Page(build: (pw.Context context) {
                  return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Agenda Perjalanan',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Column(
                            children: res!.wisata!.agenda
                                .map((e) => pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text('Hari ke ${e.dayOfNumber}'),
                                          pw.Column(
                                            children: e.agenda
                                                .map((e) => pw.Padding(
                                                      padding: const pw
                                                          .EdgeInsets.only(
                                                        top: 5,
                                                      ),
                                                      child: pw.Row(
                                                        crossAxisAlignment: pw
                                                            .CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          pw.SizedBox(
                                                            width: 90,
                                                            child: pw.Text(
                                                                '${e.startTime} - ${e.endTime}'),
                                                          ),
                                                          pw.Expanded(
                                                            child: pw.Text(
                                                                e.deskripsi),
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                          pw.SizedBox(height: 10),
                                        ]))
                                .toList()),
                        pw.SizedBox(height: 10),
                        pw.Text('Pemandu : ${res!.wisata!.pemandu}'),
                        pw.SizedBox(height: 20),
                        pw.Text('Daftar Peserta',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 5),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: res!.transaction!.listTraveler
                                .map((e) => pw.Text(
                                    '- ${e.nama}(${e.umur}th) ${e.jenisKelamin}'))
                                .toList()),
                        pw.SizedBox(height: 20),
                      ]);
                }));
              }

              String namaFile = '$nama $phone';

              final file = File('${directory.path}/$namaFile.pdf');
              await file.writeAsBytes(await pdf.save()).then((value) async {
                await Share.shareFiles(['${directory.path}/$namaFile.pdf'],
                        subject: namaFile)
                    .then((value) {
                  log('_ SUKSES');
                }).catchError((onError) {
                  log('_ GAGAL $onError');
                });
              }).catchError((onError) {
                log('_GAGAL $onError');
              });
            }).catchError((onError) {
              log('ERROR $onError');
            });
          });
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Rincian Transaksi'),
      backgroundColor: whiteColor,
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionSuccessGet) {
            res = state.res;
            log('RES $res');

            title = '';
            nama = res!.transaction!.namaUser;
            email = res!.transaction!.emailUser;
            phone = res!.transaction!.phoneUser;
            kategori = res!.transaction!.category;
            imageUrl = res!.transaction!.imageTransfer;
            jumlah = res!.transaction!.listTraveler.length;
            tglKeberangkatan = DateFormat("dd MMMM yyyy")
                .format(res!.transaction!.tanggalBerangkat);
            biaya = '';
            total = '';
            status = res!.transaction!.status;
            deskripsiStatus = '';

            if (status == 0) {
              deskripsiStatus = 'Menuggu persetujuan';
            } else if (status == 1) {
              deskripsiStatus = 'Disetujui';
            } else if (status == 2) {
              deskripsiStatus = 'Sedang berlangsung';
            } else if (status == 3) {
              deskripsiStatus = 'Ditolak';
            }

            var formatter = DateFormat('dd MMM yyyy hh:mm');
            tglTransaksi = formatter.format(res!.transaction!.timeCreated);

            String toIdr(int s) {
              return NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(s);
            }

            if (res!.transaction!.category == 'WISATA') {
              if (res!.wisata != null) {
                var wisata = res!.wisata;
                title = wisata!.nama;
                biaya = toIdr(wisata.biaya);
                total = toIdr(wisata.biaya * jumlah);
              }
            } else {
              if (res!.travel != null) {
                var travel = res!.travel;
                title = travel!.nama;
                biaya = toIdr(travel.biaya);
                total = toIdr(travel.biaya * jumlah);
              }
            }
          } else if (state is TransactionFailedGet) {
            return NotFoundItem(text: 'Terjadi suatu kesalahan');
          } else if (state is TransactionLoadingGet) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            color: whiteColor,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detail Pelanggan',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        itemRow('Nama', nama),
                        itemRow('Nomor hp', phone),
                        itemRow('Email', email),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: greyColor,
                          margin: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        Text(
                          'Detail Pemesanan',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        itemRow('Id tagihan', idInvoice),
                        itemRow('Nama', title),
                        itemRow('Kategori', kategori),
                        itemRow('Jumlah kursi', '$jumlah Orang'),
                        itemRow('Tanggal keberangkatan', tglKeberangkatan),
                        // itemRow('Status', deskripsiStatus),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: greyColor,
                          margin: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                        Text(
                          'Detail Pembayaran',
                          style: blackTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        itemRow('Waktu pembayaran', tglTransaksi),
                        itemRow('Biaya', biaya),
                        itemRow('Total Pembayaran', total),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPhotoPage(imageUrl: imageUrl),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: DottedBorder(
                              child: Center(
                                child: Hero(
                                  tag: 'transfer',
                                  child: Image.network(imageUrl),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        btnCetak(),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                )),
                status == 0 && role != ROLE.user ? button() : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
