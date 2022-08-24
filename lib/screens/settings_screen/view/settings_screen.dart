// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../domain/user_authentication/user_authentication_impl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

TextEditingController _name = TextEditingController();

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final uid = user!.uid;

                  print(uid);
                },
                child: Text("UserId")),
            ElevatedButton(
                onPressed: () async {
                  _name.clear();
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Neue Person hinzufügen'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _name,
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  labelText: "Name",
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Center(
                              child: FlatButton(
                                onPressed: () async {
                                  context.loaderOverlay.show();

                                  Navigator.pop(context);

                                  // Navigator.of(context).pop();
                                },
                                textColor: Theme.of(context).primaryColor,
                                child: const Text('Ok'),
                              ),
                            ),
                          ],
                        );
                      });

                  dynamic userData = await UserAuthenticationImpl().signUpUser(
                      "${_name.text}@tracker.at", "123456", _name.text);

                  UserAuthenticationImpl().signOutUser();

                  await UserAuthenticationImpl()
                      .signInUser("mathias@tracker.at", "Thüringerberg6721");

                  context.loaderOverlay.hide();

                  userData.fold((userData) {
                    showFlash(
                      context: context,
                      duration: const Duration(seconds: 4),
                      builder: (context, controller) {
                        return Flash.bar(
                            backgroundColor: Colors.white,
                            enableVerticalDrag: true,
                            horizontalDismissDirection:
                                HorizontalDismissDirection.startToEnd,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            controller: controller,
                            child: FlashBar(
                              content: Text("${_name.text} wurde hinzugefügt."),
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 24,
                              ),
                              shouldIconPulse: true,
                            ));
                      },
                    );
                  }, (failure) {
                    showFlash(
                      context: context,
                      duration: const Duration(seconds: 4),
                      builder: (context, controller) {
                        return Flash.bar(
                            backgroundColor: Colors.white,
                            enableVerticalDrag: true,
                            horizontalDismissDirection:
                                HorizontalDismissDirection.startToEnd,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            controller: controller,
                            child: FlashBar(
                              content: Text(
                                  "Neue Person konnte nicht hinzugefügt werden."),
                              icon: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                              shouldIconPulse: true,
                            ));
                      },
                    );
                  });
                },
                child: Text("Neue Person hinzufügen"))
          ],
        )),
      ),
    );
  }
}
