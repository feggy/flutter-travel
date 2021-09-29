import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travel_wisata/models/alamat_travel_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/select_address_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({Key? key}) : super(key: key);

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

var permStatus = false;
String nama = '';

class _SearchAddressPageState extends State<SearchAddressPage>
    with WidgetsBindingObserver {
  var jalan = TextEditingController(text: '');
  var kecamatan = TextEditingController(text: '');
  var kelurahan = TextEditingController(text: '');
  var kabupaten = TextEditingController(text: '');
  var provinsi = TextEditingController(text: '');
  var postalCode = TextEditingController(text: '');

  List<Placemark> placemarks = [];
  AlamatKoordinat? alamat;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    permissionRequest();
    _getCurrentLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final status = await Permission.location.status;
      _getCurrentLocation();
      if (status.isGranted) {
        setState(() {
          permStatus = true;
        });
      }
    }
  }

  Widget permNeed() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Aplikasi membutuhkan akses lokasi untuk mendapatkan koordinat Anda',
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 15,
        ),
        CustomButton(
            title: 'BERI IZIN LOKASI',
            width: 150,
            onPressed: () {
              openSettingReq();
            })
      ],
    );
  }

  Widget alamatFromKoordinat(AlamatKoordinat? alamat) {
    return Text(
      '${alamat!.jalan}, ${alamat.kecamatan}, ${alamat.kelurahan}\n${alamat.kabupaten}\n${alamat.provinsi}\n${alamat.postalCode}',
      style: blackTextStyle.copyWith(
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarItem(title: 'Tambahkan Alamat'),
      backgroundColor: whiteColor,
      body: permStatus == false
          ? permNeed()
          : SingleChildScrollView(
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
                      'Pilih alamat berdasarkan koordinat',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      'Diharapkan saat menambahkan alamat Anda sedang berada di alamat penjemputan',
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SelectAddressPage(placemarks: placemarks),
                          ),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              alamat = value as AlamatKoordinat;
                              jalan.text = alamat!.jalan!;
                              kecamatan.text = alamat!.kecamatan!;
                              kelurahan.text = alamat!.kelurahan!;
                              kabupaten.text = alamat!.kabupaten!;
                              provinsi.text = alamat!.provinsi!;
                              postalCode.text = alamat!.postalCode!;
                            });
                          }
                          log('GET $value');
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: grey2Color,
                        ),
                        child: alamat == null
                            ? Center(
                                child: Text(
                                  'Klik disini untuk memilih alamat',
                                  style: blackTextStyle,
                                ),
                              )
                            : alamatFromKoordinat(alamat),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Lakukan penyesuaian bila di perlukan',
                      style: greyTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Jalan',
                      controller: jalan,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Kecamatan',
                      controller: kecamatan,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Kelurahan',
                      controller: kelurahan,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Kabupaten',
                      controller: kabupaten,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Provinsi',
                      controller: provinsi,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomInputText(
                      label: 'Kode Pos',
                      controller: postalCode,
                      imeOption: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        title: 'SIMPAN',
                        onPressed: () {
                          String errorMsg = '';
                          if (jalan.text.isEmpty) {
                            errorMsg = 'Kolom jalan tidak boleh kosong';
                          } else if (kecamatan.text.isEmpty) {
                            errorMsg = 'Kolom kecamatan tidak boleh kosong';
                          } else if (kelurahan.text.isEmpty) {
                            errorMsg = 'Kolom kelurahan tidak boleh kosong';
                          } else if (kabupaten.text.isEmpty) {
                            errorMsg = 'Kolom kabupaten tidak boleh kosong';
                          } else if (provinsi.text.isEmpty) {
                            errorMsg = 'Kolom provisin tidak boleh kosong';
                          }

                          if (errorMsg.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMsg),
                                backgroundColor: redColor,
                              ),
                            );
                          } else {}
                        }),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void permissionRequest() async {
    var status = await Permission.accessMediaLocation.status;
    if (status.isGranted) {
      setState(() {
        permStatus = true;
      });
    }
  }

  void openSettingReq() async {
    var req = await Permission.accessMediaLocation.request();
    if (req.isDenied) {
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
}
