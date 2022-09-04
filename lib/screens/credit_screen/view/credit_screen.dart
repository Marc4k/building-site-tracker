import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/styles.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Credits",
                style: heading1Style,
              ),
            ),
            SizedBox(height: 25.h),
            Text("Image by macrovector"),
            GestureDetector(
              onTap: () {
                final Uri _url = Uri.parse(
                    'https://www.freepik.com/free-vector/builders-with-construction-vehicle-lighting-equipment_7437895.htm#query=building%20site&position=31&from_view=search');
                launchUrl(_url);
              },
              child: Text(
                "https://www.freepik.com/free-vector/builders-with-construction-vehicle-lighting-equipment_7437895.htm#query=building%20site&position=31&from_view=search",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Text("on Freepik"),
            SizedBox(height: 25.h),
            Text("Image by pch.vector"),
            GestureDetector(
              onTap: () {
                final Uri _url = Uri.parse(
                    'https://www.freepik.com/free-vector/building-material-heaps-set_5585200.htm#query=building%20site&position=11&from_view=search%23position=11&query=building%20site');
                launchUrl(_url);
              },
              child: Text(
                "https://www.freepik.com/free-vector/building-material-heaps-set_5585200.htm#query=building%20site&position=11&from_view=search%23position=11&query=building%20site",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Text("on Freepik"),
            SizedBox(height: 25.h),

            Text("Illustration by Ornella Pagliaruolo"),
            Text("Animation by Beló Qu"),

            GestureDetector(
              onTap: () {
                final Uri _url = Uri.parse(
                    'https://www.behance.net/gallery/72969113/Animated-buildings');
                launchUrl(_url);
              },
              child: Text(
                "https://www.behance.net/gallery/72969113/Animated-buildings",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Text("on behance"),
            Spacer(),
            Text("Made in Austria"),
            Text("by Marc"),

//
          ],
        ),
      )),
    );
  }
}
