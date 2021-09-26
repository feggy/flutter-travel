import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_wisata/shared/theme.dart';
import 'package:travel_wisata/ui/widgets/not_found_item.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: NotFoundItem(text: 'Belum ada agenda sedang\nberlangsung'),
    );
  }
}
