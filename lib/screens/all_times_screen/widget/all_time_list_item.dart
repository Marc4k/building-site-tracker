import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../constants/styles.dart';

class AllTimeListItem extends StatelessWidget {
  const AllTimeListItem(
      {Key? key,
      required this.date,
      required this.time,
      required this.hour,
      required this.onTapDelete,
      required this.onTapEdit})
      : super(key: key);
  final String date;
  final String time;
  final int hour;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onTapEdit,
                      child: Icon(
                        Icons.edit,
                        size: 17.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: onTapDelete,
                      child: Icon(
                        Icons.delete,
                        size: 17.r,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 2.w),
                Text(
                  time,
                  style: bodyStyle,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Divider(thickness: 1),
      ],
    );
  }
}
