// ignore_for_file: deprecated_member_use

import 'package:building_site_tracker/cubit/get_names_data_cubit.dart';
import 'package:building_site_tracker/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        body: SafeArea(
            child: Column(
          children: [
            Center(
              child: Text("Baustellen Tracker"),
            ),
            BlocBuilder<GetNamesDataCubit, List<String>>(
              builder: (context, names) {
                if (names.isEmpty) {
                  context.loaderOverlay.show();
                  return Container();
                } else {
                  context.loaderOverlay.hide();
                  return Expanded(
                    child: ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return ElevatedButton(
                            onPressed: () async {
                              context.loaderOverlay.show();

                              dynamic user = await UserAuthenticationImpl()
                                  .signInUser(
                                      "${names[index]}@tracker.at", "123456");
                              context.loaderOverlay.hide();
                              user.fold((userData) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        MultiBlocProvider(providers: [
                                          BlocProvider<GetNamesDataCubit>(
                                              create: (BuildContext context) =>
                                                  GetNamesDataCubit())
                                        ], child: HomeScreen())));
                              }, (failure) {});
                            },
                            child: Text(names[index]));
                      },
                    ),
                  );
                }
              },
            )
          ],
        )),
      ),
    );
  }
}
