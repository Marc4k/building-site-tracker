import 'package:building_site_tracker/constants/colors.dart';
import 'package:building_site_tracker/constants/pw.dart';
import 'package:building_site_tracker/cubit/get_building_site_data_cubit.dart';
import 'package:building_site_tracker/cubit/get_names_data_cubit.dart';
import 'package:building_site_tracker/cubit/get_time_data_cubit.dart';
import 'package:building_site_tracker/cubit/start_stop_cubit.dart';
import 'package:building_site_tracker/cubit/timer_cubit.dart';
import 'package:building_site_tracker/domain/building_site/building_site_impl.dart';
import 'package:building_site_tracker/screens/all_times_screen/view/all_time_screen.dart';
import 'package:building_site_tracker/screens/building_sites/widget/building_site_item.dart';
import 'package:building_site_tracker/screens/time_tracker_site/view/time_tracker_site.dart';
import 'package:building_site_tracker/screens/user_settings_screen/view/user_settings_screen.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../constants/styles.dart';

class BuildingSiteScreen extends StatefulWidget {
  const BuildingSiteScreen({Key? key, required this.name}) : super(key: key);

  final String name;
  @override
  State<BuildingSiteScreen> createState() => _BuildingSiteScreenState();
}

TextEditingController _name = TextEditingController();
TextEditingController _passwort = TextEditingController();

class _BuildingSiteScreenState extends State<BuildingSiteScreen> {
  bool isLocked = false;
  bool klickedOnButton = false;
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
                    widget.name,
                    style: heading1Style,
                  ),
                  Spacer(),
                  Visibility(
                    visible: !isLocked,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MultiBlocProvider(providers: [
                                    BlocProvider<GetNamesDataCubit>(
                                        create: (BuildContext context) =>
                                            GetNamesDataCubit()..getNames()),
                                  ], child: UserSettingScreen())));
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: 20.r,
                        )),
                  ),
                  Visibility(
                    visible: !isLocked,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MultiBlocProvider(providers: [
                                    BlocProvider<GetNamesDataCubit>(
                                        create: (BuildContext context) =>
                                            GetNamesDataCubit()..getNames()),
                                    BlocProvider<GetBuildingSiteDataCubit>(
                                        create: (BuildContext context) =>
                                            GetBuildingSiteDataCubit()
                                              ..getNames()),
                                    BlocProvider<GetTimeDataCubit>(
                                        create: (BuildContext context) =>
                                            GetTimeDataCubit()),
                                  ], child: AllTimeScreen())));
                        },
                        icon: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.black,
                          size: 20.r,
                        )),
                  ),
                  Visibility(
                    visible: widget.name == "Mathias",
                    child: IconButton(
                        onPressed: () async {
                          if (isLocked == true) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Entsperren'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _passwort,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            hintText: "Passwort",
                                            labelText: "Passwort",
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
                                              if (_passwort.text == PW.pass) {
                                                setState(() {
                                                  isLocked = false;
                                                });
                                                Navigator.pop(context);

                                                showFlash(
                                                  context: context,
                                                  duration: const Duration(
                                                      seconds: 4),
                                                  builder:
                                                      (context, controller) {
                                                    return Flash.bar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        enableVerticalDrag:
                                                            true,
                                                        horizontalDismissDirection:
                                                            HorizontalDismissDirection
                                                                .startToEnd,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        controller: controller,
                                                        child: FlashBar(
                                                          content: Text(
                                                              "Entsperrt!"),
                                                          icon: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                            size: 24,
                                                          ),
                                                          shouldIconPulse: true,
                                                        ));
                                                  },
                                                );
                                              }
                                            },
                                            child: Text("entsperren")),
                                      )
                                    ],
                                  );
                                });
                          } else {
                            setState(() {
                              isLocked = true;
                            });
                          }

                          _passwort.clear();
                        },
                        icon: Icon(
                          isLocked
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                          color: Colors.black,
                          size: 20.r,
                        )),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              BlocBuilder<GetBuildingSiteDataCubit, List<String>>(
                builder: (context, names) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      if (names.isEmpty) {
                        context.loaderOverlay.show();

                        return Container();
                      } else {
                        return BuildingSiteItem(
                            onDeleteTap: () async {
                              context.loaderOverlay.show();

                              await BuildingSiteImpl()
                                  .deleteBuildingSite(name: names[index]);
                              context.loaderOverlay.hide();

                              context
                                  .read<GetBuildingSiteDataCubit>()
                                  .getNames();
                            },
                            isLocked: isLocked,
                            name: names[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                          providers: [
                                            BlocProvider<StartStopCubit>(
                                                create:
                                                    (BuildContext context) =>
                                                        StartStopCubit()
                                                          ..setStartActive()),
                                            BlocProvider<TimerCubit>(
                                                create:
                                                    (BuildContext context) =>
                                                        TimerCubit()
                                                          ..getCurrentTimeC(
                                                              names[index])),
                                            BlocProvider<GetTimeDataCubit>(
                                                create:
                                                    (BuildContext context) =>
                                                        GetTimeDataCubit()
                                                          ..getTimeData(
                                                              names[index]))
                                          ],
                                          child: TimeTrackerSite(
                                            name: names[index],
                                          ))));
                            });
                      }
                    },
                  ));
                },
              )
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
                    title: const Text('Neue Baustelle hinzufügen'),
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
            context.loaderOverlay.show();
            if (_name.text.isEmpty) {
              return;
            }
            if (klickedOnButton == false) {
              return;
            }
            await BuildingSiteImpl().createNewBuildingSite(name: _name.text);
            context.read<GetBuildingSiteDataCubit>().getNames();

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
            context.loaderOverlay.hide();
          },
          child: Icon(Icons.add_location_alt_rounded),
        ),
      ),
    );
  }
}
