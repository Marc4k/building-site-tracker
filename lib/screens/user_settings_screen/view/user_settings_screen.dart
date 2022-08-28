import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../cubit/get_building_site_data_cubit.dart';
import '../../../cubit/get_names_data_cubit.dart';
import '../../../domain/user_authentication/user_authentication_impl.dart';
import '../widget/user_list_item.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

TextEditingController _name = TextEditingController();

class _UserSettingScreenState extends State<UserSettingScreen> {
  bool klickedOnButton = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mitarbeiter Verwaltung",
                  style: heading1Style,
                ),
              ),
              SizedBox(height: 30.h),
              BlocBuilder<GetNamesDataCubit, List<String>>(
                builder: (context, names) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        if (names[index] == "Mathias") {
                          return Container();
                        } else {
                          return UserListItem(
                              name: names[index],
                              onDeleteTap: () async {
                                context.loaderOverlay.show();

                                await UserAuthenticationImpl()
                                    .deleteUser(name: names[index]);

                                context.loaderOverlay.hide();
                                context.read<GetNamesDataCubit>().getNames();

                                showFlash(
                                  context: context,
                                  duration: const Duration(seconds: 4),
                                  builder: (context, controller) {
                                    return Flash.bar(
                                        backgroundColor: Colors.white,
                                        enableVerticalDrag: true,
                                        horizontalDismissDirection:
                                            HorizontalDismissDirection
                                                .startToEnd,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        controller: controller,
                                        child: FlashBar(
                                          content: Text(
                                              "${names[index]} wurde gelöscht."),
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                          shouldIconPulse: true,
                                        ));
                                  },
                                );
                              });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CustomColors.yellow,
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
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                primary: CustomColors.yellow),
                            onPressed: () {
                              klickedOnButton = true;

                              Navigator.pop(context);
                            },
                            child: Text("hinzufügen")),
                      )
                    ],
                  );
                });
            if (klickedOnButton == false) {
              return;
            }
            context.loaderOverlay.show();

            klickedOnButton = false;
            dynamic userData = await UserAuthenticationImpl()
                .signUpUser("${_name.text}@tracker.at", "123456", _name.text);

            UserAuthenticationImpl().signOutUser();

            await UserAuthenticationImpl()
                .signInUser("mathias@tracker.at", "123456");

            userData.fold((userData) {
              context.loaderOverlay.hide();
              context.read<GetNamesDataCubit>().getNames();
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
              context.loaderOverlay.hide();

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
          child: Icon(Icons.person_add),
        ),
      ),
    );
  }
}
