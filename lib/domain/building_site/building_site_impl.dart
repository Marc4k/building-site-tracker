import 'package:building_site_tracker/domain/building_site/building_site_rep.dart';
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
  Future<void> createNewBuildingSite({required String name}) async {
    final document =
        FirebaseFirestore.instance.collection('buildingsite').doc();

    await document.set({
      "name": name,
    });
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
