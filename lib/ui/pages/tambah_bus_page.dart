import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/models/travel_model.dart';
import 'package:travel_wisata/services/travel_service.dart';
import 'package:travel_wisata/services/user_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:path/path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';

class TambahBusPage extends StatefulWidget {
  final TravelModel? data;

  const TambahBusPage({Key? key, this.data}) : super(key: key);

  @override
  State<TambahBusPage> createState() => _TambahBusPageState();
}

class _TambahBusPageState extends State<TambahBusPage> {
  final namaController = TextEditingController(text: '');

  final biayaController = TextEditingController(text: '');

  final classController = TextEditingController(text: '');

  final spesifikasiController = TextEditingController(text: '');

  final fasilitasController = TextEditingController(text: '');

  final supirController = TextEditingController(text: '');

  final _picker = ImagePicker();
  String imageUrl = '';
  var bytes;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      namaController.text = widget.data!.nama;
      biayaController.text = widget.data!.biaya.toString();
      classController.text = widget.data!.kelas;
      spesifikasiController.text = widget.data!.spesifikasi;
      fasilitasController.text = widget.data!.fasilitas;
    }
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

    Widget buttonSimpan() {
      return BlocConsumer<TravelCubit, TravelState>(
        listener: (context, state) {
          if (state is TravelSuccessAdd) {
            String response = state.response;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: greenColor,
                content: Text(response),
              ),
            );
            Navigator.pop(context);
          } else if (state is TravelSuccessEdit) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Berhasil mengubah data'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.admin, (route) => false);
                      },
                      child: const Text('OK'))
                ],
              ),
            );
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
            onPressed: () async {
              String errorMsg = '';

              var nama = namaController.text;
              var biaya = biayaController.text;
              var kelas = classController.text;
              var spesifikasi = spesifikasiController.text;
              var fasilitas = fasilitasController.text;
              var supir = supirController.text;
              // var supirCheck = await UserService()
              //     .checkUserAvailable(supirController.text, 'SUPIR');

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
                if (widget.data == null) {
                  errorMsg = "foto belum dipilih";
                } else {
                  imageUrl = widget.data!.imageUrl;
                }
              }
              // else if (supir.isEmpty) {
              //   errorMsg = "Kolom email supir tidak boleh kosong";
              // }
              // else if (supirCheck == false) {
              //   errorMsg = "Data supir tidak ditemukan";
              // }

              if (errorMsg.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMsg),
                    backgroundColor: redColor,
                  ),
                );
              } else {
                if (widget.data == null) {
                  context.read<TravelCubit>().addTravel(
                        nama: nama,
                        biaya: int.parse(biaya),
                        kelas: kelas,
                        spesifikasi: spesifikasi,
                        fasilitas: fasilitas,
                        imageUrl: imageUrl,
                        supir: supir,
                      );
                } else {
                  context.read<TravelCubit>().editTravel(
                        id: widget.data!.id,
                        nama: nama,
                        biaya: int.parse(biaya),
                        kelas: kelas,
                        spesifikasi: spesifikasi,
                        fasilitas: fasilitas,
                        imageUrl: imageUrl,
                      );
                }
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

    Widget inputSupir() {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: TextFormField(
          cursorColor: Colors.black,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          style: blackTextStyle.copyWith(
            fontWeight: regular,
            fontSize: 14,
          ),
          controller: supirController,
          decoration: InputDecoration(
            label: Text(
              'Email Supir',
              style: greyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: regular,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBarItem(
        title: widget.data == null ? 'Tambah Travel' : 'Ubah Travel',
      ),
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
                    // inputSupir(),
                    // const SizedBox(
                    //   height: 20,
                    // ),
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
