import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/bank_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:path/path.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({Key? key}) : super(key: key);

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _picker = ImagePicker();
  String? imagePath;
  String imageUrl = '';
  var bytes;

  @override
  void initState() {
    _picker;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    var transaction = arguments['transaction'] as TransactionModel;

    log('TRANSACTION $transaction');

    Future uploadImage(File fileImage) async {
      String filename = basename(fileImage.path);
      var _ref = FirebaseStorage.instance
          .ref()
          .child('tour_travel/transfer/$filename');
      UploadTask uploadTask = _ref.putFile(fileImage);
      uploadTask.whenComplete(() async {
        imageUrl = await _ref.getDownloadURL();
        log('imageUrl $imageUrl');
      }).catchError((err) {
        log('error $err');
      });
    }

    void pickImageFromGallery() async {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        uploadImage(File(pickedImage!.path));
        bytes = File(pickedImage.path).readAsBytesSync();
      });
    }

    Widget loadImage() {
      return Image.memory(bytes);
    }

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
                    child: bytes == null
                        ? const Image(
                            image: AssetImage('assets/image_upload.png'),
                            width: 50,
                          )
                        : loadImage()),
              ),
            ),
          ],
        ),
      );
    }

    Widget buttonUpload() {
      return BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccessAdd) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/sukses_pembayaran', (route) => false);
          } else if (state is TransactionFailedAdd) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: redColor,
              content: Text(state.response),
            ));
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomButton(
              title: 'SELESAI',
              onPressed: () {
                if (imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        const Text('Upload bukti transfer terlebih dahulu'),
                    backgroundColor: redColor,
                  ));
                } else {
                  transaction.imageTransfer = imageUrl;
                  context
                      .read<TransactionCubit>()
                      .addTransaction(data: transaction);
                }
              });
        },
      );
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
