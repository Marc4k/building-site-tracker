import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowAllTimesWidget extends StatelessWidget {
  const ShowAllTimesWidget(
      {Key? key, required this.date, required this.time, required this.hour})
      : super(key: key);
  final String date;
  final String time;
  final double hour;
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
          radius: 23.r,
          backgroundColor: CustomColors.yellow,
          child: Text(
            double.parse((hour).toStringAsFixed(1)).toString(),
            style: subheading2Style,
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
