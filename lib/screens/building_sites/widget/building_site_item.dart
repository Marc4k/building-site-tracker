import 'package:building_site_tracker/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildingSiteItem extends StatelessWidget {
  const BuildingSiteItem({Key? key, required this.name, required this.onTap})
      : super(key: key);
  final String name;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 18.h),
          Row(
            children: [
              Image.asset(
                "assets/image/schub.png",
                height: 25.h,
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                name,
                style: subheading1Style,
              )
            ],
          ),
          SizedBox(height: 18.h),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
