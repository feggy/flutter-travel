// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/lokasi_model.dart';
import 'package:travel_wisata/models/role_enum.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/services/wisata_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/absen_page.dart';
import 'package:travel_wisata/ui/pages/pemandu/daftar_agenda.dart';
import 'package:travel_wisata/ui/pages/wisata_detail_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/model_2_card.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HalamanKendaliPemandu extends StatefulWidget {
  final WisataModel data;
  final ROLE role;
  ResTransaciton? res;

  HalamanKendaliPemandu({
    Key? key,
    required this.data,
    required this.role,
    this.res,
  }) : super(key: key);

  @override
  State<HalamanKendaliPemandu> createState() => _HalamanKendaliPemanduState();
}

var permStatus = false;

class _HalamanKendaliPemanduState extends State<HalamanKendaliPemandu> {
  List<Placemark> placemarks = [];
  String lat = '';
  String lng = '';

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log('location $position');
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    lat = position.latitude.toString();
    lng = position.longitude.toString();
  }

  void permissionRequest() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      setState(() {
        permStatus = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    permissionRequest();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget higlightWisata() {
      return Stack(
        children: [
          Model2Card(
              nama: widget.res!.wisata!.nama,
              harga: widget.res!.wisata!.deskripsiHari,
              deskripsi: '',
              imageUrl: widget.res!.wisata!.imageUrl),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WisataDetailPage(
                        data: widget.res!.wisata!,
                        role: ROLE.pemandu,
                        res: widget.res,
                      ),
                    ));
              },
              child: Text(
                'Lihat Detail',
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget detailPelanggan() {
      if (widget.role != ROLE.user) {
        return Column(
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
              height: 5,
            ),
            Row(
              children: [
                Text(
                  'Pelanggan',
                  style: greyTextStyle.copyWith(fontSize: 11),
                ),
                Expanded(
                  child: Text(
                    widget.res!.transaction!.namaUser,
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Nomor hp',
                  style: greyTextStyle.copyWith(fontSize: 11),
                ),
                Expanded(
                  child: Text(
                    widget.res!.transaction!.phoneUser,
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Tanggal wisata',
                  style: greyTextStyle.copyWith(fontSize: 11),
                ),
                Expanded(
                  child: Text(
                    DateFormat("dd MMMM yyyy")
                        .format(widget.res!.transaction!.tanggalBerangkat),
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
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

    showAlert(
      String title,
      String desc,
    ) {
      Widget cancelButton = TextButton(
        child: const Text("Oke"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: [
          cancelButton,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void openSettingReq() async {
      var req = await Permission.location.request();
      if (req.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Akses Lokasi',
              style: blackTextStyle.copyWith(
                fontWeight: semiBold,
              ),
            ),
            content: Text(
              'Aplikasi membutuhkan akses lokasi untuk mendapatkan titik koordinat lokasi Anda',
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
                  'Tolak',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: Text(
                  'Pengaturan',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }

    Widget buttonMulaiWisata() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/sukses_wisata', (route) => false);
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
            return const Center(child: CircularProgressIndicator());
          }
          return SingleTextCard(
              text: 'Mulai wisata',
              onPressed: () {
                if (permStatus) {
                  showAlertDialog(
                      'Mulai Wisata', 'Apakah Anda yakin memulai wisata?', () {
                    Navigator.pop(context);
                    context.read<TransactionCubit>().updateStatus(
                        idInvoice: widget.res!.transaction!.idInvoice,
                        status: 2);
                  });
                } else {
                  showAlertDialog(
                      'Izin lokasi',
                      'Aplikasi membutuhkan izin lokasi untuk membagikan koordinat',
                      () => openSettingReq());
                }
              });
        },
      );
    }

    Widget buttonSelesai() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/akhiri_wisata', (route) => false);
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
            return const Center(child: CircularProgressIndicator());
          }
          return SingleTextCard(
              text: 'Akhiri wisata',
              onPressed: () {
                showAlertDialog(
                    'Akhiri Wisata', 'Apakah Anda yakin mengakhiri wisata?',
                    () {
                  Navigator.pop(context);
                  context.read<TransactionCubit>().updateStatus(
                      idInvoice: widget.res!.transaction!.idInvoice, status: 4);
                });
              });
        },
      );
    }

    Widget absenPeserta() {
      return SingleTextCard(
          text: 'Absen peserta',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbsenPage(res: widget.res!),
              ),
            );
          });
    }

    Widget ubahAgenda() {
      return SingleTextCard(
          text: 'Ubah Agenda',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaftarAgenda(res: widget.res!),
              ),
            );
          });
    }

    Widget bagikanLokasi() {
      return SingleTextCard(
          text: 'Bagikan lokasi',
          onPressed: () async {
            await WisataService()
                .shareLocation(
              data: LokasiModel(
                pemandu: widget.res!.wisata!.pemandu,
                idWisata: widget.res!.wisata!.id,
                timeCreated: DateTime.now(),
                lat: lat,
                lng: lng,
              ),
            )
                .then((value) {
              showAlert('Bagikan lokasi', value);
            }).catchError((onError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(onError),
                backgroundColor: redColor,
              ));
            });
          });
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Halaman Kendali'),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              higlightWisata(),
              const SizedBox(height: 40),
              detailPelanggan(),
              const SizedBox(height: 20),
              widget.res!.transaction!.status != 4
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Kendali',
                          style: blackTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        widget.res!.transaction!.status == 1
                            ? buttonMulaiWisata()
                            : Column(
                                children: [
                                  absenPeserta(),
                                  const SizedBox(height: 10),
                                  bagikanLokasi(),
                                  const SizedBox(height: 10),
                                  ubahAgenda(),
                                  const SizedBox(height: 10),
                                  buttonSelesai(),
                                ],
                              ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
