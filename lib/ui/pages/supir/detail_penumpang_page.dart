import 'package:flutter/material.dart';
import 'package:travel_wisata/models/alamat_travel_model.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/services/travel_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/single_text_card.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPenumpangPage extends StatefulWidget {
  final ResTransaciton res;

  const DetailPenumpangPage({Key? key, required this.res}) : super(key: key);

  @override
  State<DetailPenumpangPage> createState() => _DetailPenumpangPageState();
}

class _DetailPenumpangPageState extends State<DetailPenumpangPage> {
  JemputPenumpang? jemput;

  void statusJemput() async {
    await TravelService()
        .getPenunmpang(
            widget.res.transaction!.idTravel, widget.res.transaction!.idInvoice)
        .then((value) {
      setState(() {
        jemput = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    statusJemput();
  }

  @override
  void dispose() {
    jemput = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void launchUrl(String latitude, String longitude) async {
      String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      await canLaunch(googleUrl)
          ? await launch(googleUrl)
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SizedBox(),
              ),
            );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Detail Penumpang'),
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Pemesan',
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Nama',
                  style: greyTextStyle.copyWith(fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    widget.res.transaction!.namaUser,
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Nomor hp',
                  style: greyTextStyle.copyWith(fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    widget.res.transaction!.phoneUser,
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'Email',
                  style: greyTextStyle.copyWith(fontSize: 12),
                ),
                Expanded(
                  child: Text(
                    widget.res.transaction!.emailUser,
                    style: blackTextStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Data Penumpang',
              style: blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.res.transaction!.listTraveler
                  .map((e) => Text(
                        '- ${e.nama} ${e.umur}th ${e.jenisKelamin}',
                        style: blackTextStyle.copyWith(fontSize: 12),
                        textAlign: TextAlign.right,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 15),
            jemput != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan: Pemesan meminta untuk di jemput',
                        style: blackTextStyle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Alamat',
                        style: greyTextStyle.copyWith(fontSize: 12),
                      ),
                      Text(
                        jemput!.alamat,
                        style: blackTextStyle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      SingleTextCard(
                          text: 'Lihat posisi pemesan',
                          onPressed: () async {
                            launchUrl(jemput!.lat, jemput!.lng);
                          }),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
