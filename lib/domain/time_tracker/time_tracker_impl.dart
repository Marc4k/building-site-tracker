import 'package:building_site_tracker/domain/time_tracker/time_tracker_rep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeTrackerImpl extends TimeTrackerRep {
  @override
  Future<void> startTimer({required String name}) async {
    DateTime now = DateTime.now();
    String buildingSiteId = "";
    await FirebaseFirestore.instance
        .collection("buildingsite")
        .where("name", isEqualTo: name)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        buildingSiteId = element.id;
      });
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    final document = FirebaseFirestore.instance.collection('time').doc();

    await document.set({
      "userID": uid,
      "buildingSiteId": buildingSiteId,
      "startTime": now,
      "stopTime": now,
      "isFinished": false
    });
  }

  @override
  Future<void> stopTimer({required String name}) async {
    DateTime now = DateTime.now();
    String id = "";
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    var collection = FirebaseFirestore.instance.collection('time');

    await FirebaseFirestore.instance
        .collection("time")
        .where("userID", isEqualTo: uid)
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
  }

  @override
  Future<Duration> getCurrentTime({required String name}) async {
    String buildingSiteId = "";
    await FirebaseFirestore.instance
        .collection("buildingsite")
        .where("name", isEqualTo: name)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        buildingSiteId = element.id;
      });
    });

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
}
