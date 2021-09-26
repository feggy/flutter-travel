import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/cubit/page_cubit.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void removePref() async {
      final pref = await SharedPreferences.getInstance();
      pref.clear();
    }

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: redColor,
          ));
        } else if (state is AuthInitial) {
          removePref();
          context.read<PageCubit>().reset();
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: Center(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is AuthSuccess) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hallo,\n${state.user.name} 👋',
                        style: blackTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: semiBold,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Ubah Profile',
                          style: greyTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: regular,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        title: 'LOGOUT',
                        width: 195,
                        onPressed: () {
                          context.read<AuthCubit>().logout();
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}
