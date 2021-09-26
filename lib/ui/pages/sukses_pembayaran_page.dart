import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class SuksesPembayaranPage extends StatelessWidget {
  const SuksesPembayaranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
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
                'Terimakasih!',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Pemintaan Anda akan segera di proses, duduk santai dan siapkan kebutuhan Tour and Travel Anda, kami akan segera menghubungi Anda',
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
                  title: 'Kembali ke Beranda',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => false);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
