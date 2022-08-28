import 'package:building_site_tracker/constants/colors.dart';
import 'package:building_site_tracker/constants/styles.dart';
import 'package:flutter/material.dart';

class ShowAllTimesWidget extends StatelessWidget {
  const ShowAllTimesWidget(
      {Key? key, required this.date, required this.time, required this.hour})
      : super(key: key);
  final String date;
  final String time;
  final int hour;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          date,
          style: bodyStyle,
        ),
        Spacer(),
        CircleAvatar(
          backgroundColor: CustomColors.yellow,
          child: Text(
            "${hour}h",
            style: subheading1Style,
          ),
        ),
        Spacer(),
        Text(
          time,
          style: bodyStyle,
        ),
      ],
    );
  }
}
