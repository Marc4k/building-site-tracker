import 'dart:async';

import 'package:building_site_tracker/cubit/get_current_time_cubit%20copy.dart';
import 'package:building_site_tracker/cubit/newTestCubit.dart';
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
  Duration duration = Duration();
  Timer? timer;

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  void setnewTime(Duration newDuration) {
    setState(() {
      duration = newDuration;
    });
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Text(widget.name),
            ElevatedButton(
                onPressed: () async {
                  startTimer();
                  await TimeTrackerImpl().startTimer(name: widget.name);
                },
                child: Text("start")),
            ElevatedButton(
                onPressed: () async {
                  timer?.cancel();
                  await TimeTrackerImpl().stopTimer(name: widget.name);
                },
                child: Text("stop")),
            BlocBuilder<NewTestCubit, Duration>(
              builder: (context, time) {
                return Text(time.inSeconds.toString());
              },
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<NewTestCubit>().addSecond();
                },
                child: Text("add")),
            ElevatedButton(
                onPressed: () {
                  context.read<NewTestCubit>().setTimer(Duration(seconds: 90));
                },
                child: Text("set")),
            ElevatedButton(
                onPressed: () {
                  context.read<NewTestCubit>().startTimer();
                },
                child: Text("start timer")),
            ElevatedButton(
                onPressed: () {
                  context.read<NewTestCubit>().stopTimer();
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
