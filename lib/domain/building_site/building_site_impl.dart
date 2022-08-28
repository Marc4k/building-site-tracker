import 'package:building_site_tracker/domain/building_site/building_site_rep.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingSiteImpl extends BuildingSiteRep {
  @override
  Future<List<String>> getAlleBuildingSiteNames() async {
    List<String> names = [];

    await FirebaseFirestore.instance
        .collection("buildingsite")
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        //Object? data = element.data();
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;

        names.add(data["name"]);
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
  Future<void> deleteBuildingSite({required String name}) async {
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

    var collection = FirebaseFirestore.instance.collection('buildingsite/');

    await collection.doc(buildingSiteId).delete();
  }
}
