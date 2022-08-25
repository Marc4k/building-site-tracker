import 'package:building_site_tracker/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenAvatar extends StatelessWidget {
  const LoginScreenAvatar({Key? key, required this.name, required this.ontap})
      : super(key: key);
  final String name;
  final VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ontap,
      child: Column(
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 40.r,
          ),
          SizedBox(height: 5.h),
          Text(
            name,
            style: subheading1Style,
          ),
          SizedBox(height: 5.h),
          Divider()
        ],
      ),
    );
  }
}
