import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:travel_wisata/models/alamat_travel_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';

class SelectAddressPage extends StatelessWidget {
  final List<Placemark> placemarks;
  const SelectAddressPage({
    Key? key,
    required this.placemarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget itemAlamat(
      String? jalan,
      String? kecamatan,
      String? kelurahan,
      String? kabupaten,
      String? provinsi,
      String? postalCode,
    ) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 15,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: grey2Color,
        ),
        child: Text(
          '$jalan, $kecamatan, $kelurahan\n$kabupaten\n$provinsi\n$postalCode',
          style: blackTextStyle.copyWith(
            fontSize: 12,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Pilih Alamat'),
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hasil pencarian alamat terdekat dilokasi Anda',
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: placemarks
                    .map((e) => GestureDetector(
                          onTap: () {
                            var alamat = AlamatKoordinat(
                              jalan: e.street,
                              kecamatan: e.locality,
                              kelurahan: e.subLocality,
                              kabupaten: e.subAdministrativeArea,
                              provinsi: e.administrativeArea,
                              postalCode: e.postalCode,
                            );
                            Navigator.pop(context, alamat);
                          },
                          child: itemAlamat(
                              e.street,
                              e.locality,
                              e.subLocality,
                              e.subAdministrativeArea,
                              e.administrativeArea,
                              e.postalCode),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
