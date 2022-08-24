import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String text = "";

class _HomeScreenState extends State<HomeScreen> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25),
            Center(
                child: Text(
              "$text",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            )),
            SizedBox(height: 25),
            Center(child: Text("$hours:$minutes:$seconds")),
            ElevatedButton(
                onPressed: () {
                  startTimer();
                },
                child: Text("start")),
            ElevatedButton(
                onPressed: () {
                  timer?.cancel();
                },
                child: Text("stop")),
            ElevatedButton(
                onPressed: () async {
                  dynamic user =
                      await FirebaseAuth.instance.signInAnonymously();
                },
                child: Text("Sign In")),
            ElevatedButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? user = auth.currentUser;
                  final uid = user!.uid;

                  setState(() {
                    text = uid;
                  });
                },
                child: Text("Test"))
          ],
        ),
      ),
    );
  }
}
