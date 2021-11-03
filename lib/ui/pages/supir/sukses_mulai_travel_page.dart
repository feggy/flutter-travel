import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class SuksesMulaiTravelPage extends StatelessWidget {
  const SuksesMulaiTravelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, '/supir_home', (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/image_success.png'),
                width: 250,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Sukses!',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Anda telah berhasil memulai perjalanan, pastikan penumpang Anda lengkap saat memulai perjalanan dan jangan lupa utamakan keselamatan, ramah dan tamah, selamat bekerja!.',
                textAlign: TextAlign.center,
                style: blackTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  title: 'Selesai',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/supir_home', (route) => false);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
