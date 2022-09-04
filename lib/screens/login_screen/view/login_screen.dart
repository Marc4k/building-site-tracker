// ignore_for_file: deprecated_member_use

import 'package:building_site_tracker/constants/styles.dart';
import 'package:building_site_tracker/cubit/get_building_site_data_cubit.dart';
import 'package:building_site_tracker/cubit/get_names_data_cubit.dart';
import 'package:building_site_tracker/screens/building_sites/view/building_site_screen.dart';
import 'package:building_site_tracker/screens/credit_screen/view/credit_screen.dart';
import 'package:building_site_tracker/screens/homescreen.dart';
import 'package:building_site_tracker/screens/login_screen/widget/login_screen_avatars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/user_authentication/user_authentication_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController _passwort = TextEditingController();
String error = "";
bool isVisible = true;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Mitarbeiter",
                    style: heading1Style,
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return CreditScreen();
                        }));
                      },
                      icon: Icon(Icons.info_outline))
                ],
              ),
              SizedBox(height: 40.h),
              BlocBuilder<GetNamesDataCubit, List<String>>(
                builder: (context, names) {
                  if (names.isEmpty) {
                    context.loaderOverlay.show();
                    return Expanded(child: Container());
                  } else {
                    context.loaderOverlay.hide();

                    return Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: names.length,
                            itemBuilder: (context, index) {
                              return LoginScreenAvatar(
                                name: names[index],
                                ontap: () async {
                                  context.loaderOverlay.show();

                                  dynamic user = await UserAuthenticationImpl()
                                      .signInUser("${names[index]}@tracker.at",
                                          "123456");
                                  context.loaderOverlay.hide();
                                  user.fold((userData) async {
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider<
                                                              GetBuildingSiteDataCubit>(
                                                          create: (BuildContext
                                                                  context) =>
                                                              GetBuildingSiteDataCubit()
                                                                ..getNames())
                                                    ],
                                                    child: BuildingSiteScreen(
                                                        name: names[index]))));

                                    context
                                        .read<GetNamesDataCubit>()
                                        .getNames();
                                  }, (failure) {});
                                },
                              );
                            }));
                  }
                },
              ),
              Image.asset("assets/image/building.jpeg")
            ],
          ),
        )),
      ),
    );
  }
}
