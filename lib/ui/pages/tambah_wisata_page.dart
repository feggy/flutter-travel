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
import 'package:travel_wisata/services/user_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/pages/pemandu/ubah_agenda_page.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';
import 'package:travel_wisata/ui/widgets/hari_agenda_item.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TambahWisataPage extends StatefulWidget {
  final WisataModel? data;

  const TambahWisataPage({Key? key, this.data}) : super(key: key);

  @override
  State<TambahWisataPage> createState() => _TambahWisataPageState();
}

class _TambahWisataPageState extends State<TambahWisataPage> {
  final namaController = TextEditingController(text: '');

  final biayaController = TextEditingController(text: '');

  final deskripsiHariController = TextEditingController(text: '');

  final pemanduController = TextEditingController(text: '');

  final _picker = ImagePicker();
  String imageUrl = '';
  var bytes;

  List<HariModel> dataList = [];

  @override
  void initState() {
    super.initState();
    _picker;

    if (widget.data != null) {
      namaController.text = widget.data!.nama;
      biayaController.text = widget.data!.biaya.toString();
      deskripsiHariController.text = widget.data!.deskripsiHari;
      pemanduController.text = widget.data!.pemandu;

      setState(() {
        dataList = widget.data!.agenda;
      });
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
            Navigator.pop(context);
          } else if (state is WisataSuccessEdit) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Berhasil'),
                content: const Text('Berhasil mengubah data'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/admin', (route) => false);
                      },
                      child: const Text('OK'))
                ],
              ),
            );
          } else if (state is WisataFailedAdd) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: redColor,
              content: Text(state.error),
            ));
          }
        },
        builder: (context, state) {
          if (state is WisataLoadingAdd) {
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
              onPressed: () async {
                String errorMsg = '';
                var nama = namaController.text;
                var biaya = biayaController.text;
                var deskripsi = deskripsiHariController.text;
                var pemandu = pemanduController.text;
                var pemanduCheck =
                    await UserService().checkUserAvailable(pemandu, 'PEMANDU');

                log('message $pemanduCheck');

                if (nama.isEmpty) {
                  errorMsg = "Kolom nama tidak boleh kosong";
                } else if (biaya.isEmpty) {
                  errorMsg = "Kolom biaya tidak boleh kosong";
                } else if (deskripsi.isEmpty) {
                  errorMsg =
                      "Kolom deskripsi lama perjalanan tidak boleh kosong";
                } else if (imageUrl.isEmpty) {
                  if (widget.data == null) {
                    errorMsg = "Upload cover terlebih dahulu";
                  } else {
                    imageUrl = widget.data!.imageUrl;
                  }
                } else if (dataList.isEmpty) {
                  errorMsg = "Agenda harus diisi";
                } else if (pemandu.isEmpty) {
                  errorMsg = "Kolom pemandu tidak boleh kosong";
                } else if (pemanduCheck == false) {
                  errorMsg = "Data pemandu tidak ditemukan";
                }

                if (errorMsg.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMsg),
                      backgroundColor: redColor,
                    ),
                  );
                } else {
                  if (widget.data == null) {
                    context.read<WisataCubit>().addWisata(
                          nama: namaController.text,
                          biaya: int.parse(biayaController.text),
                          deskripsiHari: deskripsiHariController.text,
                          imageUrl: imageUrl,
                          agenda: dataList,
                          pemandu: pemandu,
                        );
                  } else {
                    context.read<WisataCubit>().editWisata(
                          id: widget.data!.id,
                          nama: namaController.text,
                          biaya: int.parse(biayaController.text),
                          deskripsiHari: deskripsiHariController.text,
                          imageUrl: imageUrl,
                          agenda: dataList,
                          pemandu: pemandu,
                        );
                  }
                }
              });
        },
      );
    }

    Widget inputPemandu() {
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
          controller: pemanduController,
          decoration: InputDecoration(
            label: Text(
              'Email Pemandu',
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

    Widget listWisata() {
      Widget titleHari(HariModel data) {
        return Text(
          'Hari ke ${data.dayOfNumber}',
          style: blackTextStyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
        );
      }

      Widget listAgenda(HariModel data) {
        data.agenda = data.agenda
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        return Column(
          children: data.agenda
              .map((e) => GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UbahAgendaPage(
                            dayNumber: data.dayOfNumber,
                            agenda: e,
                          ),
                        ),
                      ).then((value) {
                        log('value $value');
                        if (value != null) {
                          HariModel set = value;

                          setState(() {
                            dataList
                                .firstWhere((element) => element == data)
                                .agenda
                                .remove(e);

                            dataList
                                .firstWhere((element) => element == data)
                                .agenda
                                .add(set.agenda[0]);
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              '${e.startTime} - ${e.endTime}',
                              style: blackTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: regular,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.deskripsi,
                              style: blackTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: regular,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      }

      return Column(
          children: dataList
              .map(
                (e) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleHari(e),
                    listAgenda(e),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
              .toList());
    }

    return Scaffold(
      appBar: AppBarItem(
          title: widget.data == null ? 'Tambah Wisata' : 'Ubah Wisata'),
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
                  inputPemandu(),
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
                    listWisata()
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
