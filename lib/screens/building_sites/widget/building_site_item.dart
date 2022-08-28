import 'package:building_site_tracker/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildingSiteItem extends StatelessWidget {
  const BuildingSiteItem(
      {Key? key,
      required this.name,
      required this.onTap,
      required this.isLocked,
      required this.onDeleteTap})
      : super(key: key);
  final String name;
  final VoidCallback onTap;
  final bool isLocked;
  final VoidCallback onDeleteTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 14.h),
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
              ),
              Spacer(),
              Visibility(
                  visible: !isLocked,
                  child: GestureDetector(
                      onTap: onDeleteTap, child: Icon(Icons.delete))),
            ],
          ),
          SizedBox(height: 14.h),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
