import 'package:flutter/material.dart';
import 'package:travel_wisata/models/wisata_model.dart';
import 'package:travel_wisata/shared/theme.dart';

class HariAgendaItem extends StatelessWidget {
  final HariModel data;

  const HariAgendaItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleHari() {
      return Text(
        'Hari ke ${data.dayOfNumber}',
        style: blackTextStyle.copyWith(
          fontSize: 12,
          fontWeight: medium,
        ),
      );
    }

    Widget listAgenda() {
      return Column(
        children: data.agenda
            .map((e) => Padding(
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
                ))
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHari(),
        listAgenda(),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
