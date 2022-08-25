import 'dart:async';

import 'package:building_site_tracker/cubit/get_current_time_cubit%20copy.dart';
import 'package:building_site_tracker/cubit/timer_cubit.dart';
import 'package:building_site_tracker/domain/time_tracker/time_tracker_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TimeTrackerSite extends StatefulWidget {
  const TimeTrackerSite({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<TimeTrackerSite> createState() => _TimeTrackerSiteState();
}

bool startBlur = false;
bool stopBlur = true;

class _TimeTrackerSiteState extends State<TimeTrackerSite> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Text(widget.name),
            BlocBuilder<TimerCubit, Duration>(
              builder: (context, time) {
                if (time.inDays == 99) {
                  context.loaderOverlay.hide();
                  context.read<TimerCubit>().setTimer(Duration(seconds: 0));
                  return Text("00:00:00");
                } else if (time.inSeconds == 1) {
                  context.loaderOverlay.show();
                  return Text("00:00:00");
                } else {
                  context.loaderOverlay.hide();
                  //context.read<TimerCubit>().startTimer();

                  String twoDigitsGang(int n) => n.toString().padLeft(2, '0');
                  final hours = twoDigitsGang(time.inHours);
                  final minutes = twoDigitsGang(time.inMinutes.remainder(60));
                  final seconds = twoDigitsGang(time.inSeconds.remainder(60));

                  return Text("$hours:$minutes:$seconds");
                }
              },
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: startBlur ? Colors.grey : Colors.blue),
                onPressed: () {
                  if (startBlur == false) {
                    context.read<TimerCubit>().startTimer();
                    setState(() {
                      startBlur = true;
                    });
                  }
                },
                child: Text("start timer")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: stopBlur ? Colors.grey : Colors.blue),
                onPressed: () {
                  setState(() {
                    startBlur = false;
                  });
                  context.read<TimerCubit>().stopTimer();
                },
                child: Text("stop timer"))

            /*   BlocBuilder<GetCurrentTimeCubit, Duration>(
              builder: (context, time) {
                if (time.inDays == 99) {
                  context.loaderOverlay.hide();
                } else if (time.inSeconds == 0) {
                  context.loaderOverlay.show();
                } else {
                  context.loaderOverlay.hide();
                  duration = time;
                  startTimer();
                }

                return Center(child: Text("$hours:$minutes:$seconds"));
              },
            ),*/
          ],
        )),
      ),
    );
  }
}
