import 'package:dartz/dartz.dart';

import '../../error/failures.dart';
import 'building_site_rep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/building_site_model.dart';

class BuildingSiteImpl extends BuildingSiteRep {
  @override
  Future<List<BuildingSiteModel>> getAlleBuildingSiteNames() async {
    List<BuildingSiteModel> names = [];

    await FirebaseFirestore.instance
        .collection("buildingsite")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        names.add(BuildingSiteModel(name: data["name"], id: element.id));
      });
    });

    return names;
  }

  @override
  Future<Either<String, Failure>> createNewBuildingSite(
      {required String name}) async {
    bool isSame = false;

    await FirebaseFirestore.instance
        .collection("buildingsite")
        .where("name", isEqualTo: name)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        isSame = true;
      });
    });

    if (isSame == false) {
      final document =
          FirebaseFirestore.instance.collection('buildingsite').doc();

      await document.set({
        "name": name,
      });
      String message = "$name wurde hinzugefügt.";
      return left(message);
    } else {
      return right(BuildingSiteFailure(
          errorMessage: "Diese Baustelle existiert bereits."));
    }
  }

  @override
  Future<void> deleteBuildingSite({required String buildingSiteId}) async {
    await FirebaseFirestore.instance
        .collection("time")
        .where("buildingSiteId", isEqualTo: buildingSiteId)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        element.reference.delete();
      });
    });
    var collection = FirebaseFirestore.instance.collection('buildingsite/');

    await collection.doc(buildingSiteId).delete();
  }
}
