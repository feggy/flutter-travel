import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/bank_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _picker = ImagePicker();
  String? imagePath;
  @override
  void initState() {
    _picker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget listBank() {
      return Column(
        children: [
          BankItem(
              image: 'assets/bca.png',
              noRek: '203947684',
              nameRek: 'PT. Travel Indo'),
          BankItem(
              image: 'assets/bri.png',
              noRek: '203947684',
              nameRek: 'PT. Travel Indo'),
          BankItem(
              image: 'assets/bsi.png',
              noRek: '203947684',
              nameRek: 'PT. Travel Indo'),
        ],
      );
    }

    void pickImageFromGallery() async {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedImage != null) {
          imagePath = pickedImage.path;
        }
      });
    }

    ImageProvider loadImage() {
      if (imagePath != null) {
        return FileImage(File(imagePath!));
      }

      return const AssetImage('assets/image_upload.png');
    }

    Widget upload() {
      return GestureDetector(
        onTap: () {
          pickImageFromGallery();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload bukti transfer',
              style: blackTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DottedBorder(
              color: blackColor,
              child: Container(
                width: 120,
                height: 150,
                color: grey2Color,
                child: Center(
                  child: Image(
                    image: loadImage(),
                    width: imagePath == null ? 50 : double.infinity,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonUpload() {
      return CustomButton(
          title: 'UPLOAD',
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/sukses_pembayaran', (route) => false);
          });
    }

    Widget buttonCancel() {
      return CustomButton(
        title: 'BATALKAN PEMESANAN',
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
        },
        color: redColor,
      );
    }

    Widget deskripsiTransfer() {
      return Text(
        'Berhasil melakukan pemesanan paket wisata.\nPembayaran dapat dilakukan melalui transfer ke rekening berikut:',
        style: blackTextStyle.copyWith(
          fontSize: 14,
          fontWeight: regular,
        ),
      );
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBarItem(title: 'Pembayaran'),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  deskripsiTransfer(),
                  const SizedBox(
                    height: 20,
                  ),
                  listBank(),
                  const SizedBox(
                    height: 20,
                  ),
                  upload(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            buttonCancel(),
            const SizedBox(
              height: 20,
            ),
            buttonUpload(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
