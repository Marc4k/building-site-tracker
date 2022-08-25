import 'package:building_site_tracker/cubit/get_building_site_data_cubit.dart';
import 'package:building_site_tracker/cubit/get_current_time_cubit%20copy.dart';
import 'package:building_site_tracker/cubit/timer_cubit.dart';
import 'package:building_site_tracker/domain/building_site/building_site_impl.dart';
import 'package:building_site_tracker/screens/time_tracker_site/view/time_tracker_site.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

class BuildingSiteScreen extends StatefulWidget {
  const BuildingSiteScreen({Key? key}) : super(key: key);

  @override
  State<BuildingSiteScreen> createState() => _BuildingSiteScreenState();
}

TextEditingController _name = TextEditingController();

class _BuildingSiteScreenState extends State<BuildingSiteScreen> {
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            BlocBuilder<GetBuildingSiteDataCubit, List<String>>(
              builder: (context, names) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    if (names.isEmpty) {
                      return Text("Empty");
                    } else {
                      return ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider<GetCurrentTimeCubit>(
                                              create: (BuildContext context) =>
                                                  GetCurrentTimeCubit(
                                                      names[index])
                                                    ..getTime()),
                                          BlocProvider<TimerCubit>(
                                              create: (BuildContext context) =>
                                                  TimerCubit()
                                                    ..getCurrentTimeC(
                                                        names[index]))
                                        ],
                                        child: TimeTrackerSite(
                                          name: names[index],
                                        ))));
                          },
                          child: Text(names[index]));
                    }
                  },
                ));
              },
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
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
            context.loaderOverlay.show();
            if (_name.text.isEmpty) {
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
