import 'dart:developer';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/user_service.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/app_bar_item.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';
import 'package:travel_wisata/ui/widgets/custom_input_text.dart';

import '../../main.dart';

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({Key? key}) : super(key: key);

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  var email = '';
  late UserModel user;

  var namaController = TextEditingController(text: '');
  var phoneController = TextEditingController(text: '');
  var alamatController = TextEditingController(text: '');
  var emailController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  final TextEditingController birthController2 =
      TextEditingController(text: '');

  var gender = '';
  var role = '';

  void getData() async {
    await SharedPreferences.getInstance().then((value) async {
      email = value.getString('email') ?? '';
      role = value.getString('role') ?? '';
      await UserService().getUserByEmail(email).then((value) {
        if (value != null) {
          user = value;

          namaController.text = user.name;
          birthController2.text = DateFormat('dd MMM yyyy').format(user.birth);
          phoneController.text = user.phone;
          alamatController.text = user.address;

          setState(() {
            gender = user.gender;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget inputGender() {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (builder) => Scaffold(
              backgroundColor: transparentColor,
              body: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: whiteColor,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pilih jenis kelamin',
                        style: blackTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                gender = 'LK';
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100,
                              height: 35,
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Center(
                                child: Text(
                                  'Laki-laki',
                                  style: blackTextStyle,
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: blackColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                gender = 'PR';
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 100,
                              height: 35,
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Center(
                                child: Text(
                                  'Perempuan',
                                  style: blackTextStyle,
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: blackColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1,
                    color: greyColor,
                  )),
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                  gender,
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
              ),
            ),
            Container(
              color: whiteColor,
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                'Jenis Kelamin',
                style: greyTextStyle.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
      );
    }

    Widget inputTanggalLahir() {
      final format = DateFormat("dd MMMM yyyy");
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: DateTimeField(
            format: format,
            style: blackTextStyle.copyWith(
              fontWeight: regular,
              fontSize: 14,
            ),
            controller: birthController2,
            decoration: InputDecoration(
              label: Text(
                'Tanggal lahir',
                style: greyTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 14,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                context: context,
                initialDate: currentValue ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
              );
            }),
      );
    }

    return Scaffold(
      appBar: AppBarItem(title: 'Ubah Profil'),
      backgroundColor: whiteColor,
      body: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 40,
        ),
        children: [
          CustomInputText(
            label: 'Nama',
            controller: namaController,
          ),
          const SizedBox(
            height: 15,
          ),
          inputTanggalLahir(),
          const SizedBox(
            height: 15,
          ),
          inputGender(),
          const SizedBox(
            height: 15,
          ),
          CustomInputText(
            label: 'Nomor Hp',
            controller: phoneController,
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomInputText(
            label: 'Alamat',
            controller: alamatController,
          ),
          const SizedBox(
            height: 25,
          ),
          CustomButton(
            title: 'SIMPAN',
            onPressed: () async {
              await UserService()
                  .editUser(
                email: email,
                name: namaController.text,
                birth: DateFormat("dd MMMM yyyy").parse(birthController2.text),
                gender: gender,
                phone: phoneController.text,
                address: alamatController.text,
              )
                  .then((value) {
                if (value == true) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Berhasil'),
                      content: const Text('Berhasil mengubah profil'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (role == 'ADMIN') {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, Routes.admin, (route) => false);
                              } else if (role == 'USER') {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/main', (route) => false);
                              } else if (role == 'PEMANDU') {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/pemandu_home', (route) => false);
                              }
                            },
                            child: const Text('OK'))
                      ],
                    ),
                  );
                }
              }).catchError((onError) {
                log('_ $onError');
              });
            },
          )
        ],
      ),
    );
  }
}
