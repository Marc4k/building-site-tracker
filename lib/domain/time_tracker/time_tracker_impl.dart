import 'model/time_model.dart';
import 'time_tracker_rep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TimeTrackerImpl extends TimeTrackerRep {
  @override
  Future<void> startTimer({required String buildingSiteId}) async {
    DateTime now = DateTime.now();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    final document = FirebaseFirestore.instance.collection('time').doc();

    await document.set({
      "userID": uid,
      "buildingSiteId": buildingSiteId,
      "startTime": now,
      "stopTime": now,
      "isFinished": false,
      "message": ""
    });
  }

  @override
  Future<String> stopTimer({required String buildingSiteId}) async {
    DateTime now = DateTime.now();
    String id = "";
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var collection = FirebaseFirestore.instance.collection('time');

    await FirebaseFirestore.instance
        .collection("time")
        .where("userID", isEqualTo: uid)
        .where("buildingSiteId", isEqualTo: buildingSiteId)
        .where("isFinished", isEqualTo: false)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        id = element.id;
      });
    });
    await collection.doc(id).update({"isFinished": true, "stopTime": now});

    return id;
  }

  @override
  Future<Duration> getCurrentTime({required String buildingSiteId}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    DateTime startTime = DateTime.now();
    DateTime now = DateTime.now();

    DateTime stopTime = DateTime.now();

    await FirebaseFirestore.instance
        .collection("time")
        .where("buildingSiteId", isEqualTo: buildingSiteId)
        .where("isFinished", isEqualTo: false)
        .where("userID", isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        startTime = (data['startTime'] as Timestamp).toDate();
      });
    });

    Duration diff = now.difference(startTime);

    if (diff.inSeconds == 0) {
      Duration newOne = Duration(days: 99);
      return newOne;
    }

    return diff;
  }

  @override
  Future<List<TimeModel>> getHours({required String buildingSiteId}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    List<TimeModel> timeData = [];

    await FirebaseFirestore.instance
        .collection("time")
        .where("buildingSiteId", isEqualTo: buildingSiteId)
        .where("isFinished", isEqualTo: true)
        .where("userID", isEqualTo: uid)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        DateTime startTime = (data['startTime'] as Timestamp).toDate();
        DateTime stopTime = (data['stopTime'] as Timestamp).toDate();

        //fromat Date
        DateFormat dateFormat = DateFormat("dd.MM.yyyy");
        String date =
            dateFormat.format((data['startTime'] as Timestamp).toDate());

        DateFormat dateFormatHour = DateFormat("HH:mm");
        String startTimeFromatted = dateFormatHour.format(startTime);
        String stopTimeFormatted = dateFormatHour.format(stopTime);

        Duration diff = stopTime.difference(startTime);

        int time = diff.inMinutes;
        double differenceInHour = time / 60;

        timeData.add(TimeModel(
            startTime: startTime,
            stopTime: stopTime,
            id: element.id,
            message: data['message'],
            buildingSiteId: buildingSiteId,
            date: date,
            startEndTime: "$startTimeFromatted-$stopTimeFormatted",
            hours: differenceInHour));
      });
    });

    timeData.sort((b, a) => a.startTime.compareTo(b.startTime));

    return timeData;
  }

  @override
  Future<void> deleteTime({required String id}) async {
    var collection = FirebaseFirestore.instance.collection('time/');

    await collection.doc(id).delete();
  }

  @override
  Future<void> editTime(
      {required String id,
      required DateTime newStart,
      required DateTime newEnd}) async {
    var collection = FirebaseFirestore.instance.collection('time');

    await collection
        .doc(id)
        .update({"startTime": newStart, "stopTime": newEnd});
  }

  @override
  Future<void> setMessage({required String message, required String id}) async {
    var collection = FirebaseFirestore.instance.collection('time');

    await collection.doc(id).update({"message": message});
  }
}
