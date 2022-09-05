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
      required this.onTapEdit,
      required this.isDivider,
      required this.onMessageTap,
      required this.isMessage})
      : super(key: key);
  final String date;
  final String time;
  final double hour;
  final VoidCallback onTapDelete;
  final VoidCallback onTapEdit;
  final VoidCallback onMessageTap;
  final bool isDivider;
  final bool isMessage;
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
              radius: 22.r,
              backgroundColor: CustomColors.yellow,
              child: Text(
                double.parse((hour).toStringAsFixed(1)).toString(),
                style: subheading2Style,
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: onTapEdit,
                      icon: Icon(
                        Icons.edit,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: BoxConstraints(),
                      onPressed: onTapDelete,
                      icon: Icon(
                        Icons.delete,
                        size: 17.r,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Visibility(
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        constraints: BoxConstraints(),
                        onPressed: onMessageTap,
                        icon: Icon(
                          Icons.message,
                          size: 17.r,
                          color: isMessage
                              ? Colors.black
                              : Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
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
        isDivider ? Divider(thickness: 1) : Container(),
      ],
    );
  }
}
