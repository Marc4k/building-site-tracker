import 'dart:async';

import '../../../constants/colors.dart';
import '../../../cubit/get_time_data_cubit.dart';
import '../../../cubit/start_stop_cubit.dart';
import '../../../cubit/timer_cubit.dart';
import '../../../domain/time_tracker/model/time_model.dart';
import '../../../domain/time_tracker/time_tracker_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../constants/styles.dart';
import '../widget/show_all_times_widget.dart';

class TimeTrackerSite extends StatefulWidget {
  const TimeTrackerSite(
      {Key? key, required this.buildingSiteId, required this.name1})
      : super(key: key);

  final String buildingSiteId;
  final String name1;
  @override
  State<TimeTrackerSite> createState() => _TimeTrackerSiteState();
}

class _TimeTrackerSiteState extends State<TimeTrackerSite> {
  bool canStart = true;
  @override
  void dispose() {
    // TODO: implement dispose
    context.read<TimerCubit>().stopTimer();
    super.dispose();
  }

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
              Center(
                child: Text(
                  widget.name1,
                  style: heading1Style,
                ),
              ),
              SizedBox(height: 30.h),
              BlocBuilder<TimerCubit, Duration>(
                builder: (context, time) {
                  if (time.inDays != 99 &&
                      time.inDays != 187 &&
                      time.inSeconds != 0) {
                    context.read<StartStopCubit>().setStopActive();
                    print(time);
                  }

                  if (time.inDays == 99) {
                    context.loaderOverlay.hide();
                    context.read<StartStopCubit>().setStartActive();

                    context.read<TimerCubit>().setTimer(Duration(seconds: 0));
                    return SizedBox(
                      height: 220.0.h,
                      width: 220.0.h,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 220.h,
                              height: 220.w,
                              child: CircularProgressIndicator(
                                color: CustomColors.yellow,
                                backgroundColor: CustomColors.grey,
                                strokeWidth: 20,
                                value: 0,
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            "00h 00min 00s",
                            style: subheading1Style,
                          )),
                        ],
                      ),
                    );
                  } else if (time.inDays == 187) {
                    context.loaderOverlay.show();
                    context.read<StartStopCubit>().setStartActive();

                    return SizedBox(
                      height: 220.0.h,
                      width: 220.0.h,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 220.h,
                              height: 220.w,
                              child: CircularProgressIndicator(
                                color: CustomColors.yellow,
                                backgroundColor: CustomColors.grey,
                                strokeWidth: 20,
                                value: 0,
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            "00h 00min 00s",
                            style: subheading1Style,
                          )),
                        ],
                      ),
                    );
                  } else {
                    context.loaderOverlay.hide();

                    String twoDigitsGang(int n) => n.toString().padLeft(2, '0');
                    final hours = twoDigitsGang(time.inHours);
                    final minutes = twoDigitsGang(time.inMinutes.remainder(60));
                    final seconds = twoDigitsGang(time.inSeconds.remainder(60));

                    double valueProgressBar =
                        (1 / 60) * time.inMinutes.remainder(60);

                    valueProgressBar = valueProgressBar +
                        ((1 / 60) * time.inSeconds.remainder(60) / 100);

                    // print(valueseconds);

                    return SizedBox(
                      height: 220.0.h,
                      width: 220.0.h,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 220.h,
                              height: 220.w,
                              child: CircularProgressIndicator(
                                color: CustomColors.yellow,
                                backgroundColor: CustomColors.grey,
                                strokeWidth: 15,
                                value: valueProgressBar,
                              ),
                            ),
                          ),
                          Center(
                              child: Text(
                            "${hours}h ${minutes}min ${seconds}s",
                            style: subheading1Style,
                          )),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 45.h),
              BlocBuilder<StartStopCubit, int>(
                builder: (context, indexValue) {
                  return Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: indexValue == 0 ? 5 : 0,
                              fixedSize: Size(135.w, 45.h),
                              shape: StadiumBorder(),
                              primary: CustomColors.yellow),
                          onPressed: () async {
                            if (indexValue == 0) {
                              context.read<StartStopCubit>().setStopActive();

                              context.read<TimerCubit>().startTimer();

                              await TimeTrackerImpl().startTimer(
                                  buildingSiteId: widget.buildingSiteId);
                            }
                          },
                          child: Text("Start")),
                      Spacer(flex: 2),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: indexValue == 0 ? 0 : 5,
                              fixedSize: Size(135.w, 45.h),
                              shape: StadiumBorder(),
                              primary: CustomColors.yellow),
                          onPressed: () async {
                            if (indexValue == 1) {
                              context.read<TimerCubit>().stopTimer();
                              context
                                  .read<TimerCubit>()
                                  .setTimer(Duration(seconds: 0));

                              context.read<StartStopCubit>().setStartActive();

                              await TimeTrackerImpl().stopTimer(
                                  buildingSiteId: widget.buildingSiteId);

                              context
                                  .read<GetTimeDataCubit>()
                                  .getTimeData(widget.buildingSiteId);
                            }
                          },
                          child: Text("Stop")),
                      Spacer(),
                    ],
                  );
                },
              ),
              SizedBox(height: 43.h),
              Divider(thickness: 1),
              BlocBuilder<GetTimeDataCubit, List<TimeModel>>(
                builder: (context, timeData) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: timeData.length,
                    itemBuilder: (context, index) {
                      if (timeData[index].id == "++Summe++" &&
                          timeData[index].date == "++Summe++" &&
                          timeData[index].startEndTime == "++Summe++") {
                        return Container();
                      }

                      return Column(
                        children: [
                          SizedBox(height: 10.h),
                          ShowAllTimesWidget(
                            date: timeData[index].date,
                            hour: timeData[index].hours,
                            time: timeData[index].startEndTime,
                          ),
                        ],
                      );
                    },
                  ));
                },
              )
            ],
          ),
        )),
      ),
    );
  }
}
