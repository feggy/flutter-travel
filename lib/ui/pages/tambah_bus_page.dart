import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:path/path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TambahBusPage extends StatefulWidget {
  const TambahBusPage({Key? key}) : super(key: key);

  @override
  State<TambahBusPage> createState() => _TambahBusPageState();
}

class _TambahBusPageState extends State<TambahBusPage> {
  final namaController = TextEditingController(text: '');

  final biayaController = TextEditingController(text: '');

  final classController = TextEditingController(text: '');

  final spesifikasiController = TextEditingController(text: '');

  final fasilitasController = TextEditingController(text: '');

  final _picker = ImagePicker();
  String imageUrl = '';
  var bytes;

  @override
  Widget build(BuildContext context) {
    Future uploadImage(File fileImage) async {
      String filename = basename(fileImage.path);
      var _ref = FirebaseStorage.instance.ref().child('tour_travel/$filename');
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

    Widget uploadCover() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Cover',
            style: blackTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              pickImageFromGallery();
            },
            child: DottedBorder(
              color: blackColor,
              child: Container(
                width: 80,
                height: 80,
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
          ),
        ],
      );
    }

    Widget buttonSimpan() {
      return BlocConsumer<TravelCubit, TravelState>(
        listener: (context, state) {
          if (state is TravelSuccessAdd) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: greenColor,
                content: Text(state.response),
              ),
            );
            Navigator.pop(context);
          } else if (state is TravelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: redColor,
                content: Text(state.error.split(']')[1]),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TravelLoading) {
            return const Padding(
              padding: EdgeInsets.only(
                bottom: 30,
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return CustomButton(
            title: 'SIMPAN',
            onPressed: () {
              String errorMsg = '';

              var nama = namaController.text;
              var biaya = biayaController.text;
              var kelas = classController.text;
              var spesifikasi = spesifikasiController.text;
              var fasilitas = fasilitasController.text;

              if (nama.isEmpty) {
                errorMsg = "Kolom nama tidak boleh kosong";
              } else if (biaya.isEmpty) {
                errorMsg = "Kolom biaya tidak boleh kosong";
              } else if (kelas.isEmpty) {
                errorMsg = "Kolom kelas tidak boleh kosong";
              } else if (spesifikasi.isEmpty) {
                errorMsg = "Kolom spesifikasi armada tidak boleh kosong";
              } else if (fasilitas.isEmpty) {
                errorMsg = "Kolom fasilitas tidak boleh kosong";
              } else if (imageUrl.isEmpty) {
                errorMsg = "foto belum dipilih";
              }

              if (errorMsg.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                context.read<TravelCubit>().addTravel(
                      nama: nama,
                      biaya: biaya,
                      kelas: kelas,
                      spesifikasi: spesifikasi,
                      fasilitas: fasilitas,
                      imageUrl: imageUrl,
                    );
              }
            },
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 30,
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Tambah Travel'),
      backgroundColor: whiteColor,
      body: Column(
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
                    CustomInputText(label: 'Nama', controller: namaController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputText(
                      label: 'Biaya',
                      inputType: TextInputType.number,
                      controller: biayaController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputText(
                        label: 'Kelas', controller: classController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputText(
                        label: 'Spesifikasi Armada',
                        inputType: TextInputType.multiline,
                        controller: spesifikasiController),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputText(
                      label: 'Fasilitas',
                      inputType: TextInputType.multiline,
                      controller: fasilitasController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    uploadCover(),
                  ],
                ),
              ),
            ),
          ),
          buttonSimpan(),
        ],
      ),
    );
  }
}
