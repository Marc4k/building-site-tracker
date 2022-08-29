import 'model/building_site_model.dart';

abstract class BuildingSiteRep {
  Future<List<BuildingSiteModel>> getAlleBuildingSiteNames();

  Future<void> createNewBuildingSite({required String name});

  Future<void> deleteBuildingSite({required String buildingSiteId});
}
