import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_wisata/cubit/wisata_cubit.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:travel_wisata/ui/widgets/hari_agenda_item.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TambahWisataPage extends StatefulWidget {
  const TambahWisataPage({Key? key}) : super(key: key);

  @override
  State<TambahWisataPage> createState() => _TambahWisataPageState();
}

class _TambahWisataPageState extends State<TambahWisataPage> {
  final namaController = TextEditingController(text: '');

  final biayaController = TextEditingController(text: '');

  final deskripsiHariController = TextEditingController(text: '');

  final _picker = ImagePicker();
  String imageUrl = '';
  var bytes;

  List<HariModel> dataList = [];

  @override
  void initState() {
    _picker;
    super.initState();
  }

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

    Widget buttonTambahAgenda() {
      return CustomButton(
        title: 'TAMBAH AGENDA',
        color: grey3Color,
        onPressed: () {
          Navigator.pushNamed(context, '/tambah_agenda').then((value) {
            if (value != null) {
              setState(() {
                HariModel tmp = value as HariModel;

                bool newDay = true;
                for (var i = 0; i < dataList.length; i++) {
                  if (dataList[i].dayOfNumber == tmp.dayOfNumber) {
                    newDay = false;
                    break;
                  }
                }

                if (newDay) {
                  dataList.add(tmp);
                } else {
                  for (var element in dataList) {
                    if (element.dayOfNumber == tmp.dayOfNumber) {
                      element.agenda.add(tmp.agenda.first);
                      break;
                    }
                  }
                }

                dataList.sort((a, b) => a.dayOfNumber.compareTo(b.dayOfNumber));

                log('LIST AGENDA $dataList $newDay');
              });
            }
          });
        },
        textStyle: blackTextStyle.copyWith(
          fontSize: 14,
          fontWeight: semiBold,
        ),
        height: 35,
      );
    }

    Widget buttonSimpan() {
      return BlocConsumer<WisataCubit, WisataState>(
        listener: (context, state) {
          if (state is WisataSuccessAdd) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: greenColor,
              content: Text(state.response),
            ));
          } else if (state is WisataFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: redColor,
              content: Text(state.error),
            ));
          }
        },
        builder: (context, state) {
          if (state is WisataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomButton(
              title: 'SIMPAN',
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 30,
              ),
              onPressed: () {
                if (namaController.text.isEmpty ||
                    biayaController.text.isEmpty ||
                    deskripsiHariController.text.isEmpty ||
                    imageUrl.isEmpty ||
                    dataList.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: redColor,
                      content: const Text(
                        'Mohon periksa kembali data yang akan ditambahkan',
                      ),
                    ),
                  );
                } else {
                  context.read<WisataCubit>().addWisata(
                      nama: namaController.text,
                      biaya: biayaController.text,
                      deskripsiHari: deskripsiHariController.text,
                      imageUrl: imageUrl,
                      agenda: dataList);
                  Navigator.pop(context);
                }
              });
        },
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Tambah Wisata'),
      backgroundColor: whiteColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 100,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputText(
                    label: 'Nama',
                    controller: namaController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Biaya',
                    controller: biayaController,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomInputText(
                    label: 'Deskripsi Lama Perjalanan',
                    controller: deskripsiHariController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  uploadCover(),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Agenda Perjalanan',
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (dataList.isNotEmpty)
                    Column(
                        children: dataList
                            .map(
                              (e) => HariAgendaItem(data: e),
                            )
                            .toList())
                  else
                    Center(
                      child: Text(
                        'Belum ada agenda yang ditambahkan',
                        style: blackTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  buttonTambahAgenda(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buttonSimpan(),
        ],
      ),
    );
  }
}
