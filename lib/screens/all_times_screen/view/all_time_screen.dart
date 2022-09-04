import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../cubit/get_building_site_data_cubit.dart';
import '../../../cubit/get_names_data_cubit.dart';
import '../../../cubit/get_time_data_cubit.dart';
import '../../../domain/building_site/model/building_site_model.dart';
import '../../../domain/time_tracker/model/time_model.dart';
import '../../../domain/time_tracker/time_tracker_impl.dart';
import '../../../domain/user_authentication/user_authentication_impl.dart';
import '../widget/all_time_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AllTimeScreen extends StatefulWidget {
  const AllTimeScreen({Key? key}) : super(key: key);

  @override
  State<AllTimeScreen> createState() => _AllTimeScreenState();
}

class _AllTimeScreenState extends State<AllTimeScreen> {
  String? valueProfil;
  String? valueBuildingSite;

  void dispose() async {
    // TODO: implement dispose
    await UserAuthenticationImpl().signInUser("mathias@tracker.at", "123456");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              SizedBox(height: 25.h),
              Center(
                child: BlocBuilder<GetNamesDataCubit, List<String>>(
                  builder: (context, profilNames) {
                    return Material(
                      elevation: 3,
                      color: CustomColors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(999999)),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 2.h),
                        child: DropdownButton(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            hint: Text("Wähle Mitarbeiter"),
                            style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            underline: Container(),
                            value: this.valueProfil,
                            items: profilNames.map(
                              (e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              },
                            ).toList(),
                            onChanged: (value) async {
                              context.loaderOverlay.show();

                              setState(() {
                                this.valueProfil = value.toString();
                                this.valueBuildingSite = null;
                              });

                              await UserAuthenticationImpl().signInUser(
                                  "${value.toString()}@tracker.at", "123456");
                              context.read<GetTimeDataCubit>().getTimeData("1");
                              context.loaderOverlay.hide();
                            }),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
              BlocBuilder<GetBuildingSiteDataCubit, List<BuildingSiteModel>>(
                builder: (context, buildingSites) {
                  List<String> names = [];
                  for (var i = 0; i < buildingSites.length; i++) {
                    names.add(buildingSites[i].name);
                  }

                  return Material(
                    elevation: 3,
                    color: CustomColors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(999999)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 2.h),
                      child: DropdownButton(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          underline: Container(),
                          hint: Text("Wähle Baustelle"),
                          elevation: 3,
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                          value: this.valueBuildingSite,
                          items: names.map(
                            (e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            context.loaderOverlay.show();

                            setState(() {
                              this.valueBuildingSite = value.toString();
                            });
                            final index1 = buildingSites.indexWhere(
                                (element) => element.name == value.toString());
                            context
                                .read<GetTimeDataCubit>()
                                .getTimeData(buildingSites[index1].id);

                            context.loaderOverlay.hide();
                          }),
                    ),
                  );
                },
              ),
              SizedBox(height: 25.h),
              BlocBuilder<GetTimeDataCubit, List<TimeModel>>(
                builder: (context, timeData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: timeData.length,
                      itemBuilder: (context, index) {
                        if (timeData[index].id == "++Summe++" &&
                            timeData[index].date == "++Summe++" &&
                            timeData[index].startEndTime == "++Summe++") {
                          return Column(
                            children: [
                              SizedBox(height: 10.h),
                              Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                              SizedBox(height: 5.h),
                              IntrinsicHeight(
                                child: Stack(
                                  children: [
                                    Align(
                                      child: CircleAvatar(
                                        backgroundColor: CustomColors.yellow,
                                        radius: 28.r,
                                        child: Text(
                                          double.parse((timeData[index].hours)
                                                  .toStringAsFixed(1))
                                              .toString(),
                                          style: subheading2Style,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Positioned(
                                          left: 0,
                                          child: Text(
                                            'Gesamt:',
                                            style: bodyStyle,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(height: 10.h),
                              AllTimeListItem(
                                  isMessage: timeData[index].message != "",
                                  onMessageTap: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Notiz'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(timeData[index].message)
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                StadiumBorder(),
                                                            primary:
                                                                CustomColors
                                                                    .yellow),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("schließen")),
                                              )
                                            ],
                                          );
                                        });

                                    context
                                        .read<GetBuildingSiteDataCubit>()
                                        .getNames();
                                  },
                                  isDivider: index != timeData.length - 2,
                                  onTapDelete: () async {
                                    context.loaderOverlay.show();

                                    await TimeTrackerImpl()
                                        .deleteTime(id: timeData[index].id);
                                    context.loaderOverlay.hide();

                                    String? nameBuildingSite =
                                        this.valueBuildingSite;
                                    context
                                        .read<GetTimeDataCubit>()
                                        .getTimeData(nameBuildingSite!);
                                  },
                                  onTapEdit: () async {
                                    TimeRange result =
                                        await showTimeRangePicker(
                                            context: context,
                                            fromText: "Start",
                                            toText: "Ende",
                                            strokeColor: CustomColors.yellow,
                                            handlerColor: CustomColors.grey,
                                            selectedColor: CustomColors.yellow,
                                            start: TimeOfDay(
                                                hour: timeData[index]
                                                    .startTime
                                                    .hour,
                                                minute: timeData[index]
                                                    .startTime
                                                    .minute),
                                            end: TimeOfDay(
                                                hour: timeData[index]
                                                    .stopTime
                                                    .hour,
                                                minute: timeData[index]
                                                    .stopTime
                                                    .minute),
                                            labels: [
                                              "00:00",
                                              "03:00",
                                              "06:00",
                                              "09:00",
                                              "12:00",
                                              "15:00",
                                              "18:00",
                                              "21:00"
                                            ].asMap().entries.map((e) {
                                              return ClockLabel.fromIndex(
                                                  idx: e.key,
                                                  length: 8,
                                                  text: e.value);
                                            }).toList(),
                                            labelOffset: -30,
                                            ticks: 8,
                                            ticksColor: CustomColors.yellow,
                                            ticksWidth: 2,
                                            interval: Duration(minutes: 15));

                                    context.loaderOverlay.show();

                                    DateTime newStart =
                                        timeData[index].startTime;
                                    DateTime newEnd = timeData[index].startTime;

                                    newStart = DateTime(
                                        newStart.year,
                                        newStart.month,
                                        newStart.day,
                                        result.startTime.hour,
                                        result.startTime.minute);
                                    newEnd = DateTime(
                                        newStart.year,
                                        newStart.month,
                                        newStart.day,
                                        result.endTime.hour,
                                        result.endTime.minute);

                                    await TimeTrackerImpl().editTime(
                                        id: timeData[index].id,
                                        newStart: newStart,
                                        newEnd: newEnd);
                                    context.loaderOverlay.hide();

                                    String? nameBuildingSite =
                                        this.valueBuildingSite;
                                    context
                                        .read<GetTimeDataCubit>()
                                        .getTimeData(nameBuildingSite!);
                                  },
                                  date: timeData[index].date,
                                  time: timeData[index].startEndTime,
                                  hour: timeData[index].hours),
                            ],
                          );
                        }
                      },
                    ),
                  );
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
