import '../../../constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({Key? key, required this.name, required this.onDeleteTap})
      : super(key: key);
  final String name;
  final VoidCallback onDeleteTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: subheading1Style,
        ),
        Spacer(),
        IconButton(onPressed: onDeleteTap, icon: Icon(Icons.delete, size: 20.r))
      ],
    );
  }
}
